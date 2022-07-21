class Auth::Vk::DecodeResponse
  include Interactor
  using StringCheckBase64

  delegate :vk_response_enc, :vk_response, to: :context

  def call
    context.fail!(error_data: bad_response) unless vk_response_enc.base64?
    context.vk_response = decode(vk_response_enc)

    context.fail!(error_data: no_user_id) if vk_response[:user_id].blank?

    set_context!
  end

  private

  def set_context!
    context.vk_access_token = vk_response[:access_token]
    context.user_id = vk_response[:user_id]
  end

  def decode(response_enc)
    Oj.load(Base64.strict_decode64(response_enc), symbol_keys: true)
  end

  def bad_response = unprocessable_entity("Bad base64 encoding. Can't decode VK response")

  def no_user_id = unprocessable_entity("No user_id, can't authorize")

  def unprocessable_entity(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
