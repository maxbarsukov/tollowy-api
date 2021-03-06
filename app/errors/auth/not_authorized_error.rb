# The general application policy error.  The message should include the context of why you're
# raising this exception.
#
# By inheriting from Pundit::NotAuthorizedError, we can refactor our code to use an application
# specific error instead of an error from a dependency.
# rubocop:disable Metrics/CyclomaticComplexity
class Auth::NotAuthorizedError < Auth::BasicAuthError
  def initialize(options = {})
    message = options[:message]
    options = options.except(:message)

    @error_code = (options[:error_code] if options.is_a?(Hash) && options[:error_code]) || :unauthorized

    super(options) && return if message.blank?

    case message
    when String
      super(message)
    when Array
      super(message.empty? ? options : message.to_sentence)
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
