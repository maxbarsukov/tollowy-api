class BaseController < ActionController::API
  include Pagy::Backend
  include Pundit::Authorization
  include SetLocale
end
