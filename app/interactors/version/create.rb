class Version::Create
  include Interactor

  delegate :version_params, to: :context

  def call
    context.version = Version.new(version_params)

    fail! unless context.version.save
  end

  private

  def fail! = context.fail!(error_data:)

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: context.version.errors.to_a
    )
  end
end
