class Auth::Vk::CreateOrFindUser
  include Interactor

  delegate :user_response, :email, to: :context

  def call
    return if context.existing_user

    user = User.find_by(provider: 'vk', provider_uid: user_response.id)
    if user
      context.existing_user = true
      context.user = user
      return
    end

    context.existing_user = false
    context.user = Vk::UserBuilder.new(user_response, email:).build
  end
end
