FactoryBot.define do
  factory :answer do
    body { Faker::TvShows::Simpsons.quote }
    association :question
    association :user

    trait :invalid do
      body { nil }
    end
  end
end
