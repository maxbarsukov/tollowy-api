class UpdateUserForm < ApplicationForm
  USER_ATTRIBUTES = %i[username email password].freeze
  ATTRIBUTES = (USER_ATTRIBUTES + %i[current_password]).freeze

  attr_accessor(*ATTRIBUTES)

  validates :current_password,
            existing_password: true,
            presence: true,
            unless: -> { password.blank? }

  def attribute_names
    @attribute_names ||= ATTRIBUTES
  end

  def model_attribute_names
    @model_attribute_names ||= USER_ATTRIBUTES
  end

  delegate :role=, to: :model
end
