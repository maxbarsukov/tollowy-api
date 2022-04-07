class BaseController < ActionController::API
  include Pundit::Authorization
end
