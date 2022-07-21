class Github::UserBuilder
  attr_reader :user_response

  # @param [Response::Github::UserResponse] github_user_response
  def initialize(github_user_response)
    @user_response = github_user_response
  end

  # @return [User] user object without email
  def build
    User.new(provider: 'github').tap do |user|
      user.provider_uid = user_response.id
      user.username = user_response.login

      user.bio = user_response.bio
      user.blog = user_response.blog
      user.location = user_response.location

      user.password = generate_password
    end
  end

  private

  def generate_password
    "GH#{SecureRandom.hex(10)}"
  end
end
