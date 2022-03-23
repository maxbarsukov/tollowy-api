module ApiHelper
  module_function

  def authenticated_header(options)
    user = options[:user]
    res = Auth::CreateAccessToken.call(user: user)
    Auth::CreateRefreshToken.call(user: user, jti: res.jti)
    token = res.access_token
    puts 'HERE ==================== authenticated_header'
    puts '# user.id: ', user.id
    puts '# res.jti: ', res.jti
    puts '# res.access_token: ', token

    if options[:user] && options[:request]
      request = options[:request]
      request.headers.merge!('Authorization': "Bearer #{token}")
    else
      "Bearer #{token}"
    end
  end
end
