class Auth::Confirm::GetToken
  include Interactor

  delegate :value, to: :context

  def call
    context.fail!(error_data:) if token.blank?
    context.token = token
  end

  private

  def token
    @token ||= PossessionToken.find_by(value:)
  end

  def error_data
    ErrorData.new(status: 400, code: :bad_request, title: 'Invalid value, no such token')
  end
end
