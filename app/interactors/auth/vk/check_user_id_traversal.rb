class Auth::Vk::CheckUserIdTraversal
  include Interactor

  delegate :vk_response, :user_response, to: :context

  def call
    return if user_response.id == vk_response[:user_id]

    Rails.logger.warn 'Potential User ID traversal attempt detected,' \
                      "vk_response: #{vk_response}, user_response: #{user_response}"
    context.fail!(error_data:)
  end

  private

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: "UserID in VK response and UserID you passed don't match. User ID Traversal detected"
    )
  end
end
