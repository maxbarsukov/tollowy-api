class Auth::Vk::SetVkToken
  include Interactor

  delegate :access_token_response, to: :context

  def call
    check_blank_fields!
    context.vk_access_token = access_token_response.access_token
  end

  private

  def check_blank_fields!
    context.fail!(error_data: no_access_token) if access_token_response.access_token.blank?
    context.fail!(error_data: no_user_id) if access_token_response.user_id.blank?
  end

  def no_access_token = unprocessable_entity("No access_token, can't authorize")

  def no_user_id = unprocessable_entity("No user_id, can't authorize")

  def unprocessable_entity(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
