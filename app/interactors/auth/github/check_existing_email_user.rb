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
    before_role = user.role_before_reconfirm_value.presence || -1000
    user.role_before_reconfirm_value = [before_role, user.role_value].max
    user.role = :unconfirmed
    user.save!
  end
end
