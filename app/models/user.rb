class User < ApplicationRecord
  after_create :assign_default_role

  has_secure_password
  has_secure_token :password_reset_token

  has_many :activities, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
  has_many :possession_tokens, dependent: :destroy

  rolify

  validates :email,
            length: { maximum: 50 },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true,
            presence: true

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
