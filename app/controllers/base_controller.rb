class BaseController < ActionController::API
  include Pagy::Backend
  include Pundit::Authorization
end
