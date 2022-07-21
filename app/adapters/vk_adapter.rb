class VkAdapter
  include HttpAdapter

  attr_reader :connection

  def initialize(access_token, version = '5.131')
    @connection = Faraday.new(
      url: 'https://api.vk.com',
      params: { access_token:, v: version },
      request: { timeout: 3 }
    )
  end

  # Override #check_success method because VK always returns 200
  def check_success(response) = Oj.load(response.body)['error'].nil?

  # @return [Response::Vk::UserGetResponse, Response::Vk::Error]
  def user_get(user_id, fields = 'about,nickname,screen_name,status,city,country,site')
    make_request(
      @connection.get('/method/users.get') do |req|
        req.params['user_ids'] = user_id
        req.params['fields'] = fields
      end,
      Response::Vk::UserGetResponse,
      Response::Vk::Error
    )
  end
end
