class VkAdapter
  include HttpAdapter

  attr_reader :connection, :api_version

  def initialize(access_token = nil, version = '5.131')
    @api_version = version
    @connection = Faraday.new(
      url: 'https://api.vk.com',
      params: { access_token:, v: version },
      request: { timeout: 3 }
    )
  end

  # Override #check_success method because VK always returns 200
  def check_success(response)
    json = Oj.load(response.body)
    json['error'].nil? && json['error_description'].nil?
  end

  # @return [Response::Vk::AccessTokenResponse, Response::Vk::AccessTokenError]
  def access_token(code, redirect_uri)
    make_request(
      create_oauth_connection.post('/access_token') do |req|
        req.params['code'] = code
        req.params['redirect_uri'] = redirect_uri
      end,
      Response::Vk::AccessTokenResponse,
      Response::Vk::AccessTokenError
    )
  end

  # @return [Response::Vk::UserGetResponse, Response::Vk::Error]
  def user_get(fields = 'about,nickname,screen_name,status,city,country,site')
    make_request(
      @connection.get('/method/users.get') do |req|
        req.params['fields'] = fields
      end,
      Response::Vk::UserGetResponse,
      Response::Vk::Error
    )
  end

  private

  def create_oauth_connection
    Faraday.new(
      url: 'https://oauth.vk.com',
      params: {
        client_id: ApplicationConfig['CLIENT_VK_ID'],
        client_secret: ApplicationConfig['CLIENT_VK_SECRET'],
        v: api_version
      },
      request: { timeout: 3 }
    )
  end
end
