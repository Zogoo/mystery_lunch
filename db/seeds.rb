include FactoryBot::Syntax::Methods

create_list(:user, 100, password: '!QAZ2wsx')

# TODO: Resolve duplicated code with mystery pair worker

def create_pair_data!(user, partner)
  MysteryPair.create!(user_id: user[:id], partner_id: partner[:id], lunch_date: Date.today)
end

matcher = MysteryMatcher.new(User.active)
matcher.find_mystery_pairs.each { |user, partner| create_pair_data!(user, partner) }
partner1, partner2, odd_user = matcher.take_care_odd_user
return if partner1.nil?

create_pair_data!(odd_user, partner1)
create_pair_data!(odd_user, partner2)

puts '-------- ADMIN USER INFO -----------'
admin = User.active.sample
admin.admin!
puts "username: #{admin.username}"
puts 'password: !QAZ2wsx'
