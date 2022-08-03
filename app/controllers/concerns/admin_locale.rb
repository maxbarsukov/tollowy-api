module AdminLocale
  extend ActiveSupport::Concern

  included do
    def set_admin_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(_options = {})
      { locale: I18n.locale }
    end
  end
end
