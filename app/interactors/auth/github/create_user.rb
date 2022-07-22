class Auth::Github::CreateUser
  include Interactor

  delegate :user_response, :email, to: :context

  def call
    return if context.existing_user

    context.user = Github::UserBuilder.new(user_response, email:).build
  end
end
