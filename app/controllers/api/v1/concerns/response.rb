module Api::V1::Concerns::Response
  extend ActiveSupport::Concern

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def json_error(error_data, status = :unprocessable_entity)
    case error_data
    when Array
      json_response ErrorSerializer.call(error_data), status
    when Hash
      json_response ErrorSerializer.call([error_data]), status
    else
      raise UndefinedErrorDataType
    end
  end
end
