class Auth::Vk::SetContext
  include Interactor

  delegate :vk_response, to: :context

  def call
    context.vk_access_token = vk_response[:access_token]
    context.user_id = vk_response[:user_id]
    context.new_email_passed = new_email_passed
    context.email = vk_response[:email] if vk_response[:email].present?
  end

  private

  def new_email_passed
    vk_response[:email].nil? && context.email.present?
  end
end
