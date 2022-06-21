module Api::V1::Concerns::ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from JSON::ParserError, with: :render_bad_request
    rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized
    rescue_from Auth::BasicAuthError, with: :render_unauthorized_with_code
    rescue_from Auth::UnauthenticatedError, with: :render_unauthenticated
    rescue_from Roles::UndefinedRoleTypeError, with: :render_undefined_role_type
    rescue_from Pagination::InvalidParameter, with: :render_pagination_error
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

  def render_unauthorized(exception)
    render_error_response 'Unauthorized', :unauthorized, exception.message
  end

  def render_unauthorized_with_code(exception)
    render_error_response(
      (exception.error_code.to_s.titleize || 'Unauthorized'),
      exception.error_code,
      exception.message
    )
  end

  def render_unauthenticated(exception)
    render_error_response exception.message, :unauthorized
  end

  def render_undefined_role_type(exception)
    render_error_response exception.message, :not_found
  end

  def render_pagination_error(err)
    render json: {
      errors: [
        {
          **err.data.instance_values,
          status: err.data.status.to_s,
          source: err.source
        }
      ]
    }, status: err.data.code
  end

  private

  def render_error_response(message, status, detail = nil)
    json_error(
      ErrorData.new(
        status: Rack::Utils.status_code(status).to_s,
        code: status,
        title: message,
        detail: detail
      ), status
    )
  end
end
