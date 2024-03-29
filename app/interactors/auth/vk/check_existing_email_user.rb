class Auth::Vk::CheckExistingEmailUser
  include Interactor

  delegate :access_token_response, :user_response, to: :context

  def call
    return if access_token_response.email.blank? || context.existing_user

    user = User.find_by(email: access_token_response.email)
    return unless user

    context.login_by_existing_email = true
    context.existing_user = true
    context.user = user

    user.make_unconfirmed!
    user.providers.create!(name: 'vk', uid: user_response.id)
  end
end
