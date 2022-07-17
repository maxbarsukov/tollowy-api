class GithubAdapter
  include HttpAdapter

  attr_reader :connection, :response

  def initialize(access_token)
    @connection = Faraday.new(
      url: 'https://api.github.com',
      request: { timeout: 2 },
      headers: { 'Authorization' => access_token }
    )
  end

  # @return [Response::Github::UserResponse, Response::Github::Error]
  def user
    make_request(
      @connection.get('/user'),
      Response::Github::UserResponse,
      Response::Github::Error
    )
  end

  # @return [Response::Github::UserEmailsResponse, Response::Github::Error]
  def user_emails
    make_request(
      @connection.get('/user/emails'),
      Response::Github::UserEmailsResponse,
      Response::Github::Error
    )
  end

  def success?
    !@failed
  end
end
