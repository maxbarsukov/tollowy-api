class Auth::Vk::FetchUserData
  include Interactor

  delegate :vk_access_token, to: :context

  def call
    response = VkAdapter.new(vk_access_token).user_get
    context.fail!(error_data: response.error_data) unless response.success?

    context.user_response = response
  end
end
