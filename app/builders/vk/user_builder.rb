class Vk::UserBuilder
  attr_reader :user_response, :params

  # @param [Response::Vk::UserGetResponse] vk_user_response
  def initialize(vk_user_response, params = {})
    @user_response = vk_user_response
    @params = params
  end

  # @return [User] user object
  def build
    response = Response::Vk::UserGetResponseDecorator.new(user_response)
    User.new(provider: 'vk').tap do |user|
      user.provider_uid = response.id

      user = set_attributes(user, response)
      user.email = params[:email]

      user.password = generate_password
    end
  end

  def set_attributes(user, response)
    user.username = response.username
    user.bio = response.bio
    user.blog = response.blog
    user.location = response.location
    user
  end

  private

  def generate_password
    "VK#{SecureRandom.hex(10)}"
  end
end
