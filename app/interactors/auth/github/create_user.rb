class Auth::Github::CreateUser
  include Interactor

  delegate :user_response, :email, to: :context

  def call
    return if context.existing_user

    user_response.email = email
    context.user = Github::UserBuilder.new(user_response).build
  end
end
