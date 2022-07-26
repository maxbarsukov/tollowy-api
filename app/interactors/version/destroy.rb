class Version::Destroy
  include Interactor

  delegate :version, to: :context

  def call
    version.destroy
    fail! unless version.destroyed?
  end

  private

  def fail! = context.fail!(error_data:)

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: "Can't destroy version",
      detail: context.version.errors.to_a
    )
  end
end
