FactoryBot.define do
  factory :reward do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.planet }
    association :user
    association :question

    before :create do |reward|
      file = Rack::Test::UploadedFile.new('public/apple-touch-icon.png', 'image/png')
      reward.image.attach(file)
    end
  end
end
