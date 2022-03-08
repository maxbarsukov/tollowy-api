class User < ApplicationRecord
  include Eventable
  include Rolified

  events_class ::Events::UserEvent

  has_secure_password
  has_secure_token :password_reset_token

  has_many :refresh_tokens, dependent: :destroy
  has_many :possession_tokens, dependent: :destroy

  validates :email,
            length: { maximum: 50 },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true,
            presence: true
end
