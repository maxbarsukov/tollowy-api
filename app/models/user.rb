class User < ApplicationRecord
  rolify

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :email,
            length: { maximum: 50 },
            format: { with: Devise.email_regexp },
            uniqueness: true,
            presence: true
end
