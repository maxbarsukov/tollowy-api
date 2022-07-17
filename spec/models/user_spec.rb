# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string
#  bio                    :text
#  blog                   :string
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
#  location               :string
#  password_digest        :string           not null
#  password_reset_sent_at :datetime
#  password_reset_token   :string
#  posts_count            :integer          default(0), not null
#  provider               :string           default("email"), not null
#  provider_uid           :string
#  sign_in_count          :integer          default(0), not null
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                      (email) UNIQUE
#  index_users_on_password_reset_token       (password_reset_token) UNIQUE
#  index_users_on_provider_and_provider_uid  (provider,provider_uid) UNIQUE
#  index_users_on_username                   (username) UNIQUE
#
require 'rails_helper'

describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:refresh_tokens) }
  it { is_expected.to have_many(:possession_tokens) }
end
