class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include ActiveAdminAuthenticator

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
end
