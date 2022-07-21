class Auth::Vk::FetchUserData
  include Interactor

  delegate :vk_access_token, :user_id, to: :context

  def call
    return if context.existing_user

    response = VkAdapter.new(vk_access_token).user_get(user_id)
    context.fail!(error_data: response.error_data) unless response.success?

    context.user_response = response
  end
end
