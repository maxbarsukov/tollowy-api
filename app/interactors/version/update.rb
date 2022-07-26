class Version::Update
  include Interactor

  delegate :version_params, :version, to: :context

  def call
    context.fail!(error_data:) unless update_version_form.valid? && update_version
  end

  private

  def update_version
    version.update(update_version_form.model_attributes)
  end

  def update_version_form
    @update_version_form ||= UpdateVersionForm.new(version).assign_attributes(version_params)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: version.errors.to_a + update_version_form.errors.to_a
    )
  end
end
