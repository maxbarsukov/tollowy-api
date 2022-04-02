class Auth::BasicAuthError < Pundit::NotAuthorizedError
  attr_accessor :error_code

  def initialize(options = {})
    @error_code = options[:error_code] if options.is_a?(Hash) && options[:error_code]
    @error_code ||= :unauthorized
    super
  end
end
