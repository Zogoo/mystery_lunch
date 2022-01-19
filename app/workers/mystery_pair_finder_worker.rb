class MysteryPairFinderWorker < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default

  def perform(*args)
    three_month_pairs = MysteryPair.active.by_lunch_date(3.months.ago).to_data_hash
    matcher = MysteryMatcher.new(User.all, three_month_pairs)
    matcher.find_mystery_pairs.each { |user, partner| create_pair_data!(user, partner) }
    partner1, partner2, odd_user = matcher.take_care_odd_user
    return if partner1.nil?

    create_pair_data!(odd_user, partner1)
    create_pair_data!(odd_user, partner2)
  end

  def create_pair_data!(user, partner)
    MysteryPair.create!(user_id: user[:id], partner_id: partner[:id], lunch_date: Date.today)
  end
end
