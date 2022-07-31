class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include SessionAuthenticator

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  private

  def authenticate_admin_user!
    return redirect_to admin_sign_in_path unless user_signed_in?
    return if current_user.at_least_a?(:admin)

    reset_session
    redirect_to admin_sign_in_path, alert: I18n.t('admin.sessions.alert.you_are_not_an_admin')
  end
end
