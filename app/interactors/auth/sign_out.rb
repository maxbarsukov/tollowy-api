class Auth::SignOut
  include Interactor

  delegate :user, :token, :everywhere, to: :context

  def call
    context.fail!(error_data: error_data) unless user
    refresh_tokens = user.refresh_tokens
    refresh_tokens = refresh_tokens.where(token: token) unless everywhere
    refresh_tokens.destroy_all
    context.message = 'User signed out successfully'
  end

  private

  def error_data
    ErrorData.new(
      status: 401,
      code: :unauthorized,
      title: 'Invalid credentials'
    )
  end
end
