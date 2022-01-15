FactoryBot.define do
  factory :user do
    first_name { Faker::Movies::LordOfTheRings.character }
    last_name { Faker::Movies::StarWars.character }
    email { Faker::Internet.email }
    department { ['operations', 'sales', 'marketing', 'risk', 'management', 'finance', 'HR', 'development and data'].sample }

    # Flields for devise authentication
    password { Faker::Crypto.md5 }
    confirmed_at { Time.now }
  end
end
