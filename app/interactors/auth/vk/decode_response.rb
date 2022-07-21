class Auth::Vk::DecodeResponse
  include Interactor
  using StringCheckBase64

  delegate :vk_response_enc, to: :context

  def call
    context.fail!(error_data: bad_response) unless vk_response_enc.base64?
    context.vk_response = decode(vk_response_enc)
  end

  private

  def decode(response_enc)
    Oj.load(Base64.strict_decode64(response_enc), symbol_keys: true)
  end

  def bad_response = unprocessable_entity("Bad base64 encoding. Can't decode VK response")

  def unprocessable_entity(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
