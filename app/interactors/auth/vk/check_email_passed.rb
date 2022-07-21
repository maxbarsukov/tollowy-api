class Auth::Vk::CheckEmailPassed
  include Interactor

  delegate :vk_response, to: :context

  def call
    return if context.existing_user

    context.fail!(error_data: no_email) if vk_response[:email].blank? && context.email.blank?
  end

  private

  def no_email = unprocessable_entity('No email provided by VK. Please, pass it as parameter')

  def unprocessable_entity(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
