# Raise this exception when an action requires an authenticated user but the request has no
# authenticated user.
class Auth::UserRequiredError < Auth::NotAuthorizedError
end
