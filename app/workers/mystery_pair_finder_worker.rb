class MysteryPairFinderWorker
  include Sidekiq::Worker

  def perform(*args)
    matcher = MysteryMatcher.new(User.all)
    matcher.find_mystery_pairs
    matcher.each { |user, partner| create_pair_data!(user, partner) }
    three_pairs = matcher.take_care_odd_user
    return if odd_user.nil?

    three_pairs.combination(2).each do |user, partner|
      create_pair_data!(user, partner)
    end
  end

  def create_pair_data!(user, partner)
    MysteryPair.create(user_id: user[:id], partner_id: partner[:id], lunch_date: Date.today)
  end
end
