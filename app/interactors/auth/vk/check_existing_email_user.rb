class Auth::Vk::CheckExistingEmailUser
  include Interactor

  delegate :vk_response, :user_id, to: :context

  def call
    return if vk_response[:email].blank? || context.existing_user

    user = User.find_by(email: vk_response[:email])
    return unless user

    context.login_by_existing_email = true
    context.existing_user = true
    context.user = user

    update_role!(user)
    user.providers.create!(name: 'vk', uid: user_id)
  end

  private

  def update_role!(user)
    user.role_before_reconfirm_value = user.role_value
    user.role = :unconfirmed
    user.save!
  end
end
