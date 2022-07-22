class Auth::Vk::FetchAccessToken
  include Interactor

  delegate :vk_code, :vk_redirect_uri, to: :context

  def call
    response = VkAdapter.new.access_token(vk_code, vk_redirect_uri)
    context.fail!(error_data: response.error_data) unless response.success?

    context.access_token_response = response
  end
end
