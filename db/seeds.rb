include FactoryBot::Syntax::Methods

create_list(:user, 100, password: '!QAZ2wsx')

# Create old pair data
def create_pair_data!(user, partner)
  MysteryPair.create!(user_id: user[:id], partner_id: partner[:id], lunch_date: 1.month.ago)
  MysteryPair.create!(user_id: partner[:id], partner_id: user[:id], lunch_date: 1.month.ago)
end

matcher = MysteryMatcher.new(User.active)
matcher.find_mystery_pairs.each { |user, partner| create_pair_data!(user, partner) }
partner1, partner2, odd_user = matcher.take_care_odd_user
unless partner1.nil?
  create_pair_data!(odd_user, partner1)
  create_pair_data!(odd_user, partner2)
end

# Create future mystery pairs
MysteryPairFinderWorker.perform_now

puts '-------- ADMIN USER INFO -----------'
admin = User.active.sample
admin.admin!
puts "username: #{admin.username}"
puts 'password: !QAZ2wsx'
