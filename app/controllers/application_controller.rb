class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include SessionAuthenticator
  include AdminLocale
  include SetLocale

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  rescue_from I18n::InvalidLocale, with: :redirect_to_default_locale

  private

  def redirect_to_default_locale(exception)
    redirect_to request.original_url.split('?').first, alert: exception.message
  end

  def authenticate_admin_user!
    return redirect_to admin_sign_in_path unless user_signed_in?
    return if current_user.admin?

    reset_session
    redirect_to admin_sign_in_path, alert: I18n.t('admin.sessions.alert.you_are_not_an_admin')
  end
end
