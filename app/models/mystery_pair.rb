class MysteryPair < ApplicationRecord
  belongs_to :user
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'

  scope :by_lunch_date, lambda { |value|
    where('lunch_date > :value', value: value)
  }

  scope :to_data_hash, lambda {
    # TODO
    # Improve with MysteryPair.pluck(:partner_id, :user_id).to_h and to make why all id is not in there
    pair_hash = {}
    id_pairs = pluck(:user_id, :partner_id)
    id_pairs.each do |pairs|
      pair_hash[pairs[0]] = pairs[1]
      pair_hash[pairs[1]] = pairs[0]
    end
    pair_hash
  }
end
