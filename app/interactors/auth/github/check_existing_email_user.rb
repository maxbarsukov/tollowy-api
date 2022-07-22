class Auth::Github::CheckExistingEmailUser
  include Interactor

  delegate :user_response, :email, to: :context

  def call
    return if context.existing_user

    user = User.find_by(email:)
    return unless user

    context.login_by_existing_email = true
    context.existing_user = true
    context.user = user

    update_role!(user)
    user.providers.create!(name: 'github', uid: user_response.id)
  end

  private

  def update_role!(user)
    user.role_before_reconfirm_value = user.role_value
    user.role = :unconfirmed
    user.save!
  end
end
