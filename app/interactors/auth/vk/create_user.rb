class Auth::Vk::CreateUser
  include Interactor

  delegate :user_response, :email, to: :context

  def call
    return if context.existing_user

    user_response.email = email
    context.user = Vk::UserBuilder.new(user_response).build
  end
end
