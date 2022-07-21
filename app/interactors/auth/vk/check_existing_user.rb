class Auth::Vk::CheckExistingUser
  include Interactor

  delegate :vk_response, to: :context

  def call
    user = User.find_by(provider: 'vk', provider_uid: vk_response[:user_id])
    context.existing_user = user.present?
    context.user = user if user.present?
  end
end
