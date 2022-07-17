class Auth::Github::CreateOrFindUser
  include Interactor

  delegate :user_response, to: :context

  def call
    user = User.find_by(provider: 'github', provider_uid: user_response.id)
    if user
      context.existing_user = true
      context.user = user
      return
    end

    context.existing_user = false
    context.user = Github::UserBuilder.new(user_response).build
  end
end
