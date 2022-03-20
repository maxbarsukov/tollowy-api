# Raise this exception when a banned/unconfirmed user is attempting to take an action not allowed by a
# banned/unconfirmed user.
class Auth::UserSuspendedError < Auth::NotAuthorizedError
end
