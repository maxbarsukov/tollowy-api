class Auth::UnauthenticatedError < Auth::AuthenticationError
  def initialize(msg = nil)
    super(msg || 'You need to sign in or sign up before continuing')
  end
end
