class BaseController < ActionController::API
  include Pagy::Backend
  include Pundit::Authorization

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
