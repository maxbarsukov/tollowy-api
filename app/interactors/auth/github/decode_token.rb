class Auth::Github::DecodeToken
  include Interactor
  using StringCheckBase64

  delegate :github_token_enc, to: :context

  def call
    context.fail!(error_data:) unless github_token_enc.base64?
    context.github_token = Base64.strict_decode64(github_token_enc)
  end

  private

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Unprocessable Entity',
      detail: "Can't decode GitHub token"
    )
  end
end
