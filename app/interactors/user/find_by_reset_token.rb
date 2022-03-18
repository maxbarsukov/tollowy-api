class User::FindByResetToken
  include Interactor

  delegate :reset_token, to: :context

  def call
    context.user = find_user

    context.fail!(error_data: error_data) unless context.user
  end

  private

  def find_user
    User.find_by(password_reset_token: reset_token)
  end

  def error_data
    ErrorData.new(
      status: 401,
      code: :unauthorized,
      title: 'Invalid credentials'
    )
  end
end
