FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'qwerty' }
    password_confirmation { 'qwerty' }
  end
end

