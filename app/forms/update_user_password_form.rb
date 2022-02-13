class UpdateUserPasswordForm < ApplicationForm
  PASSWORD_RESET_TTL = 15.minutes

  ATTRIBUTES = %i[password password_reset_sent_at].freeze

  attr_accessor(*ATTRIBUTES)

  validates :password,
            length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED },
            presence: true
  validates :password_reset_sent_at,
            expiration: { timeout: PASSWORD_RESET_TTL },
            presence: true

  def attribute_names
    @attribute_names ||= ATTRIBUTES
  end

  def model_attribute_names
    @model_attribute_names ||= attribute_names
  end
end
