module ApiHelper
  module_function

  def authenticated_header(options)
    user = options[:user]
    puts '========================== authenticated_header'
    puts '-- options: ', options
    puts '-- User:', user
    res = Auth::CreateAccessToken.call(user: user)
    puts '-- Access Token:', res
    puts '-- Refresh: ', Auth::CreateRefreshToken.call(user: user, jti: res.jti)
    token = res.access_token
    puts '-- Token: ', token

    if options[:user] && options[:request]
      request = options[:request]
      request.headers.merge!(Authorization: "Bearer #{token}")
    else
      "Bearer #{token}"
    end
  end
end
