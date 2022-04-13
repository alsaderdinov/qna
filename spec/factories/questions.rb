# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after :create do |question|
        file = Rack::Test::UploadedFile.new('public/apple-touch-icon.png', 'image/png')
        question.files.attach(file)
      end
    end
  end
end
