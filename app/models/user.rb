class User < ApplicationRecord
  after_create :assign_default_role

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

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
