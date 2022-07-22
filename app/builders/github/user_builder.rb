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
      user = set_attributes(user, user_response)
      user.email = params[:email]
      user.password = generate_password
    end
  end

  private

  def generate_password
    "GH#{SecureRandom.hex(10)}"
  end

  def set_attributes(user, user_response)
    user.username = user_username(user_response.login)
    user.bio = user_response.bio[0...1000]
    user.blog = user_blog(user_response.blog)
    user.location = user_response.location[0...200]
    user
  end

  def user_username(username)
    name = username.tr('-', '_')[0...25]
    name.length >= 5 ? name : "#{name}#{rand.to_s[2..5]}"
  end

  def user_blog(blog)
    blog = blog.to_s
    blog_url = !blog.start_with?('http://') && !blog.start_with?('https://') ? "https://#{blog}" : blog
    (blog_url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/).present? ? blog_url : nil
  end
end
