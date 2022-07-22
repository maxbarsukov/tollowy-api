class Response::Vk::AccessTokenError
  attr_reader :status, :message

  # @param [String] response Faraday response
  def initialize(response)
    @status = response.status
    @message = error_message(response.body)
  end

  def success? = false

  def error_data
    ErrorData.new(
      status: 424,
      code: :failed_dependency,
      title: 'Failed Dependency',
      detail: "Request to oauth.vk failed with status #{@status}. #{@message}"
    )
  end

  private

  def error_message(body)
    message = Oj.load(body)['error_description']
    message.present? ? "Message: #{message}" : "Can't get /access_token response message"
  rescue Oj::ParseError
    'Body parsing failed'
  end
end
