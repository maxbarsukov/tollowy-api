class Auth::Confirm
  include Interactor

  delegate :value, to: :context

  def call
    context.fail!(error_data:) if token.blank?

    user.update(confirmed_at: Time.current)
    user.role = :user
    token.destroy!
  end

  private

  def token
    @token ||= PossessionToken.find_by(value:)
  end

  def user
    context.user ||= token.user
  end

  def error_data
    ErrorData.new(
      status: 400,
      code: :bad_request,
      title: 'Invalid value'
    )
  end
end
