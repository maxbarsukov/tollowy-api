class User < ApplicationRecord
  include Eventable
  include Rolified

  include UserValidator

  events_class ::Events::UserEvent

  has_secure_password
  has_secure_token :password_reset_token

  has_many :refresh_tokens, dependent: :destroy
  has_many :possession_tokens, dependent: :destroy

  def role
    roles.global.first
  end
end
