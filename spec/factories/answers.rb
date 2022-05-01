FactoryBot.define do
  factory :answer do
    body { Faker::TvShows::Simpsons.quote }
    association :question
    association :user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after :create do |answer|
        file = Rack::Test::UploadedFile.new('public/apple-touch-icon.png', 'image/png')
        answer.files.attach(file)
      end
    end
  end
end
