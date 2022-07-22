class Auth::Vk::CheckExistingUser
  include Interactor

  delegate :user_response, to: :context

  def call
    provider = Provider.find_by(name: 'vk', uid: user_response.id)
    context.existing_user = provider.present?
    context.user = provider.user if provider.present?
  end
end
