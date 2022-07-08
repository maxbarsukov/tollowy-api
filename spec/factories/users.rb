# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string
#  comments_count         :integer          default(0), not null
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :citext           not null
#  follow_count           :integer          default(0), not null
#  followers_count        :integer          default(0), not null
#  following_tags_count   :integer          default(0), not null
#  following_users_count  :integer          default(0), not null
#  last_followed_at       :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  password_digest        :string           not null
#  password_reset_sent_at :datetime
#  password_reset_token   :string
#  posts_count            :integer          default(0), not null
#  sign_in_count          :integer          default(0), not null
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
      after :build do |user|
        user.role = :user
      end
    end

    trait :with_user_role do
      after :build do |user|
        user.role = :user
      end
    end

    trait :with_admin_role do
      after :build do |user|
        user.role = :admin
      end
    end

    trait :with_banned_role do
      after :build do |user|
        user.role = :banned
      end
    end
  end
end
