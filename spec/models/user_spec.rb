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
require 'rails_helper'

describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:refresh_tokens) }
  it { is_expected.to have_many(:possession_tokens) }
end
