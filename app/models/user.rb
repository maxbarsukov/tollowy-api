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
class User < ApplicationRecord
  include Eventable
  include Rolified

  include UserValidator

  events_class ::Events::UserEvent

  has_secure_password
  has_secure_token :password_reset_token

  has_many :refresh_tokens, dependent: :destroy
  has_many :possession_tokens, dependent: :destroy
end
