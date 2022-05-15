class UpdateCommentForm < ApplicationForm
  ATTRIBUTES = %i[body].freeze

  attr_accessor(*ATTRIBUTES)

  def attribute_names
    @attribute_names ||= ATTRIBUTES
  end

  def model_attribute_names
    @model_attribute_names ||= ATTRIBUTES
  end
end
