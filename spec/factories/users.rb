FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'qwertyuiop' }
    password_confirmation { 'qwertyuiop' }
  end
end
