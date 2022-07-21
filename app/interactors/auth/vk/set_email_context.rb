class Auth::Vk::SetEmailContext
  include Interactor

  delegate :vk_response, to: :context

  def call
    return if context.existing_user

    context.new_email_passed = vk_response[:email].nil? && context.email.present?
    context.email = vk_response[:email] if vk_response[:email].present?
  end
end
