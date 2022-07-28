class Auth::Confirm::CheckTokenTtl
  include Interactor

  delegate :token, to: :context

  def call
    context.fail!(error_data:) if token.expired?
  end

  private

  def error_data
    ErrorData.new(status: 401, code: :unauthorized, title: 'Confirmation token expired')
  end
end
