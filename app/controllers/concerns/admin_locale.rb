module AdminLocale
  extend ActiveSupport::Concern

  included do
    def default_url_options(_options = {})
      { locale: I18n.locale }
    end
  end
end
