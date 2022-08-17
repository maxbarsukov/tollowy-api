class User::AuthenticateByCredentials
  include Interactor

  delegate :username_or_email, :password, to: :context

  def call
    context.fail!(error_data:) unless authenticated?
    context.user = user
  end

  private

  def authenticated?
    user&.authenticate(password)
  end

  def user
    @user ||= User.find_by('lower(username) = lower(:uoe) OR lower(email) = lower(:uoe)', uoe: username_or_email)
  end

  def error_data
    ErrorData.new(
      status: 401,
      code: :unauthorized,
      title: 'Invalid credentials'
    )
  end
end
