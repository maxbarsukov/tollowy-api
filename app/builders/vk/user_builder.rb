class Vk::UserBuilder
  attr_reader :user_response

  # @param [Response::Vk::UserGetResponse] vk_user_response
  def initialize(vk_user_response)
    @user_response = vk_user_response
  end

  # @return [User] user object
  def build
    response = Response::Vk::UserGetResponseDecorator.new(user_response)
    user_with_attributes(User.new, response)
  end

  private

  def user_with_attributes(user, response)
    %i[username email bio blog location password].each do |attr|
      user.public_send(:"#{attr}=", response.public_send(attr))
    end

    user
  end
end
