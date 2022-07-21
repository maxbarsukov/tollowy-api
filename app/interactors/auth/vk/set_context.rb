class Auth::Vk::SetContext
  include Interactor

  delegate :vk_response, to: :context

  def call
    context.vk_access_token = vk_response[:access_token]
    context.user_id = vk_response[:user_id]
    context.need_to_confirm = need_to_confirm
    context.email = vk_response[:email] if vk_response[:email].present?
  end

  private

  def need_to_confirm
    vk_response[:email].nil? && context.email.present?
  end
end
