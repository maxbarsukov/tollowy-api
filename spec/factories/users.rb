# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:user_email) }
    password { 'password' }
    username { Faker::Name.unique.name }

    trait :with_reset_token do
      password_reset_token { 'reset_token' }
      password_reset_sent_at { Time.zone.now }
    end

    trait :with_known_data do
      email { '1@1.com' }
      username { '111' }
    end
  end
end
