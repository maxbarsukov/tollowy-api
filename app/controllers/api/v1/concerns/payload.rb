module Api::V1::Concerns::Payload
  extend ActiveSupport::Concern

  private

  def payload(result, payload_class, status: :ok)
    if result.success?
      json_response payload_class.create(result), status
    else
      json_error result.error_data, result.error_data.status
    end
  end
end
