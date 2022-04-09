module ActiveAdminAuthenticator
  extend ActiveSupport::Concern

  included do
    include Api::V1::Concerns::AuthenticableUser

    helper_method :current_user, :user_signed_in?

    before_action :set_authentication_header

    private

    def authenticate_admin_user!
      return redirect_to admin_sign_in_path unless user_signed_in?

      unless current_user.at_least_a?(:admin)
        reset_session
        redirect_to admin_sign_in_path, alert: I18n.t('admin.sessions.alert.you_are_not_an_admin')
      end
    end

    def set_authentication_header
      return unless session[:access_token]

      request.headers['Authorization'] = "Bearer #{session[:access_token]}"
    end
  end
end
