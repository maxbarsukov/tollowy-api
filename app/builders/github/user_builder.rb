class Github::UserBuilder
  attr_reader :user_response, :params

  # @param [Response::Github::UserResponse] github_user_response
  def initialize(github_user_response, params = {})
    @user_response = github_user_response
    @params = params
  end

  # @return [User] user object without email
  def build
    User.new.tap do |user|
      user.username = user_response.login
      user.email = params[:email]

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
