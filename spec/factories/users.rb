# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmed_at           :datetime
#  email                  :citext           not null
#  password_digest        :string           not null
#  password_reset_sent_at :datetime
#  password_reset_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_password_reset_token  (password_reset_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { generate(:user_email) }
    password { 'Password11' }
    username { Faker::Ancient.god + Faker::Number.number(digits: 5).to_s }

    trait :with_reset_token do
      password_reset_token { 'reset_token' }
      password_reset_sent_at { Time.zone.now }
    end

    trait :with_known_data do
      email { '1@1.com' }
      username { 'user1' }
    end
  end
end
