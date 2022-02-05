class MysteryPair < ApplicationRecord
  belongs_to :user
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'

  scope :by_lunch_date, lambda { |value|
    where('lunch_date > :value', value: value)
  }

  scope :group_by_user_id, lambda {
    all.group_by(&:user_id).transform_values { |pair| pair.pluck(:partner_id) }
  }

  scope :by_user, lambda { |user|
    where(user: user).or(MysteryPair.where(partner: user))
  }
end
