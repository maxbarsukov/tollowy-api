module Api::V1::Concerns::ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from JSON::ParserError, with: :render_bad_request
    rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized
    rescue_from Auth::UnauthenticatedError, with: :render_unauthenticated
  end

  def render_unprocessable_entity(exception)
    render_error_response exception.message, :unprocessable_entity
  end

  def render_not_found
    render_error_response 'Not Found', :not_found
  end

  def render_bad_request(exception)
    render_error_response exception.message, :bad_request
  end

  def render_unauthorized
    render_error_response 'Unauthorized', :unauthorized
  end

  def render_unauthenticated(exception)
    render_error_response exception.message, :unauthorized
  end

  private

  def render_error_response(message, status)
    json_response({ error: message, status: Rack::Utils.status_code(status) }, status)
  end
end
