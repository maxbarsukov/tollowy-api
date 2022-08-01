class Constraints::DevConstraint
  class << self
    include Api::V1::Concerns::AuthenticableUser

    attr_accessor :request

    def matches?(request)
      @request = request
      return false if request.session[:access_token].blank?

      set_authentication_header!
      user_signed_in? && current_user.dev?
    end

    private

    def set_authentication_header!
      return unless request.session[:access_token]

      request.headers['Authorization'] = "Bearer #{request.session[:access_token]}"
    end
  end
end
