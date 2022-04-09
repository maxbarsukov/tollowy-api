class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include ActiveAdminAuthenticator

  protect_from_forgery with: :exception
end
