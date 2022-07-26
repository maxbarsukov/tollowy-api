class UpdateVersionForm < ApplicationForm
  ATTRIBUTES = %i[v link size for_role whats_new].freeze

  attr_accessor(*ATTRIBUTES)

  def attribute_names
    @attribute_names ||= ATTRIBUTES
  end

  def model_attribute_names
    @model_attribute_names ||= ATTRIBUTES
  end
end
