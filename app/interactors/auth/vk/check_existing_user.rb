class Auth::Vk::CheckExistingUser
  include Interactor

  delegate :vk_response, to: :context

  def call
    provider = Provider.find_by(name: 'vk', uid: vk_response[:user_id])
    context.existing_user = provider.present?
    context.user = provider.user if provider.present?
  end
end
