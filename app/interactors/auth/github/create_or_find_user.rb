class Auth::Github::CreateOrFindUser
  include Interactor

  delegate :user_response, to: :context

  def call
    provider = Provider.find_by(name: 'github', uid: user_response.id)
    if provider
      context.existing_user = true
      context.user = provider.user
      return
    end

    context.existing_user = false
    context.user = Github::UserBuilder.new(user_response).build
  end
end
