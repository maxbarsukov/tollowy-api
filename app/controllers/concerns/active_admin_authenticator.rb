module ActiveAdminAuthenticator
  extend ActiveSupport::Concern

  included do
    include Api::V1::Concerns::AuthenticableUser

    helper_method :current_user, :user_signed_in?

    before_action :set_authentication_header

    private

    def authenticate_admin_user!
      redirect_to admin_sign_in_path unless user_signed_in?
    end

    def set_authentication_header
      return unless session[:access_token]

      request.headers['Authorization'] = "Bearer #{session[:access_token]}"
    end
  end
end
