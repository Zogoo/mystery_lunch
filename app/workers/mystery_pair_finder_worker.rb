class MysteryPairFinderWorker < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default

  def perform(*args)
    raise 'No active user' unless User.active.present? # skip if there is no any active user do nothing

    three_month_pairs = MysteryPair.after_at(3.months.ago).group_by_user_id
    matcher = MysteryMatcher.new(User.active, three_month_pairs)
    matcher.find_mystery_pairs.each { |user, partner| create_pair_data!(user, partner) }

    # If all user is odd then take care that user
    partner1, partner2, odd_user = matcher.take_care_odd_user
    return if partner1.nil?

    create_pair_data!(odd_user, partner1)
    create_pair_data!(odd_user, partner2)
  end

  # Job executes at 1st day of each month, so Date.today will be 1st day of that month
  def create_pair_data!(user, partner)
    MysteryPair.create!(user_id: user[:id], partner_id: partner[:id], lunch_date: Date.today + 1.month)
  end
end
