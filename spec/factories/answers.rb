FactoryBot.define do
  factory :answer do
    body { Faker::TvShows::Simpsons.quote }

    trait :invalid do
      body { nil }
    end
  end
end
