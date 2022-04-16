class Auth::SuspendedUserError < Auth::UnauthenticatedError
  def initialize(msg = nil)
    super(msg || 'You are banned')
  end
end
