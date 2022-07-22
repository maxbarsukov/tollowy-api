class Auth::Vk::DecodeVkCode
  include Interactor
  using StringCheckBase64

  delegate :vk_code_enc, to: :context

  def call
    context.fail!(error_data: bad_code) unless vk_code_enc.base64?
    context.vk_code = decode(vk_code_enc)
  end

  private

  def decode(code_enc) = Base64.strict_decode64(code_enc)

  def bad_code = unprocessable_entity("Bad base64 encoding. Can't decode VK code")

  def unprocessable_entity(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
