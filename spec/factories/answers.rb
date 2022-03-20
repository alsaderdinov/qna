FactoryBot.define do
  factory :answer do
    body { Faker::TvShows::Simpsons.random.quote }

    trait :invalid do
      body { nil }
    end
  end
end
