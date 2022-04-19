FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'qwertyuiop' }
    password_confirmation { 'qwertyuiop' }

    trait :with_rewards do
      rewards { create_list(:reward, 3) }
    end
  end
end
