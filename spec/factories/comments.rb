FactoryBot.define do
  factory :comment do
    body { Faker::TvShows::Simpsons.quote }
    association :commentable, factory: :question
  end
end
