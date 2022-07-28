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

    user.make_unconfirmed!
    user.providers.create!(name: 'github', uid: user_response.id)
  end
end
