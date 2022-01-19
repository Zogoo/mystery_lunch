FactoryBot.define do
  factory :user do
    photo do
      fixture_path = Rails.root.join("spec/fixtures/user_photos/avatar#{(1..8).to_a.sample}.png")
      Rack::Test::UploadedFile.new(fixture_path, 'image/jpg')
    end
    username { Faker::Name.first_name + SecureRandom.hex(8) }
    first_name { Faker::Movies::LordOfTheRings.character }
    last_name { Faker::Movies::StarWars.character }
    email { Faker::Internet.email }
    department { ['operations', 'sales', 'marketing', 'risk', 'management', 'finance', 'HR', 'development and data'].sample }

    # Flields for devise authentication
    password { Faker::Crypto.md5 }
    confirmed_at { Time.now }
  end
end
