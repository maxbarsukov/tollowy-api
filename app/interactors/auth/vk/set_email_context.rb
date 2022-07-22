class Auth::Vk::SetEmailContext
  include Interactor

  delegate :access_token_response, to: :context

  def call
    return if context.existing_user

    context.new_email_passed = access_token_response.email.nil? && context.email.present?
    context.email = access_token_response.email if access_token_response.email.present?
  end
end
