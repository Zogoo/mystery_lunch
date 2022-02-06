class MysteryPair < ApplicationRecord
  belongs_to :user
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'

  scope :after_at, lambda { |value|
    where('lunch_date > :value', value: value)
  }

  scope :before_at, lambda { |value|
    where('lunch_date <= :value', value: value)
  }

  scope :group_by_user_id, lambda {
    all.group_by(&:user_id).transform_values { |pair| pair.pluck(:partner_id) }
  }

  scope :by_user, lambda { |user|
    where(user: user).or(MysteryPair.where(partner: user))
  }

  scope :by_user_id, lambda { |user_id|
    where(user: user_id).or(MysteryPair.where(partner: user_id))
  }

  scope :by_different_department, lambda { |user|
    joins(:user).joins(:partner).where.not(
      user: { id: user.id, department: user.department },
      partner: { id: user.id, department: user.department }
    )
  }

  def self.remove_user(user)
    ActiveRecord::Base.transaction do
      future_pairs = MysteryPair.after_at(Date.today).where(user_id: user.id)
      # If there is no future pairs nothing need to do.
      return unless future_pairs.present?

      future_partners = future_pairs.pluck(:partner_id)
      # If removing some one who already joined 3 pairs, exclude those users
      user_with_partners = MysteryPair.after_at(Date.today)
                                      .where(user_id: future_partners)
                                      .where.not(partner_id: user.id)
                                      .pluck(:user_id)

      MysteryPair.after_at(Date.today).by_user(user).destroy_all
      user_without_partner = future_partners - user_with_partners
      return unless user_without_partner.present?

      # TODO: If you start to store than one or two months future pair data
      # this feature become more expensive, so you need to avoid to use by_different_department
      # which uses heavy joins
      user_without_partner.each do |user_id|
        user = User.find(user_id)
        add_user(user)
      end
    end
  end

  def self.add_user(user)
    # If there is no future pair data nothing need to do
    return unless MysteryPair.after_at(Date.today).exists?

    pairs = MysteryPair.by_different_department(user)
    raise 'No pair found that user able to join' unless pairs.present?

    pair = pairs.sample # select randomly if there are lot of possible pairs
    # C user joining existing pair A-B
    # A's partner [B,C]
    # B's partner [A,C]
    # C's partner [A,B]
    ActiveRecord::Base.transaction do
      MysteryPair.create!(user_id: pair.user_id, partner_id: user.id)
      MysteryPair.create!(user_id: pair.partner_id, partner_id: user.id)
      MysteryPair.create!(user_id: user.id, partner_id: pair.user_id)
      MysteryPair.create!(user_id: user.id, partner_id: pair.partner_id)
    end
  end
end
