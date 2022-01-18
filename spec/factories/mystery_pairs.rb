FactoryBot.define do
  factory :mystery_pair do
    user { create(:user) }
    partner { create(:user) }
  end
end
