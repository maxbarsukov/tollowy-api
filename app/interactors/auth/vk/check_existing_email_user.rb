class Auth::Vk::CheckExistingEmailUser
  include Interactor

  delegate :vk_response, to: :context

  def call
    return if vk_response[:email].blank? || context.existing_user

    user = User.find_by(email: vk_response[:email])
    return unless user

    context.login_by_existing_email = true
    context.existing_user = true
    context.user = user

    # TODO: Add VK as a provider here
    user.provider = 'vk'
    user.provider_uid = context.user_id

    user.role_before_reconfirm_value = user.role_value
    user.role = :unconfirmed
    user.save!
  end
end
