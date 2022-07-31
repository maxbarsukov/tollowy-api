module SessionAuthenticator
  extend ActiveSupport::Concern

  included do
    include Api::V1::Concerns::AuthenticableUser

    helper_method :current_user, :user_signed_in?

    before_action :set_authentication_header

    private

    def set_authentication_header
      return unless session[:access_token]

      request.headers['Authorization'] = "Bearer #{session[:access_token]}"
    end
  end
end
