# The general application policy error.  The message should include the context of why you're
# raising this exception.
#
# By inheriting from Pundit::NotAuthorizedError, we can refactor our code to use an application
# specific error instead of an error from a dependency.
class Auth::NotAuthorizedError < Pundit::NotAuthorizedError
end
