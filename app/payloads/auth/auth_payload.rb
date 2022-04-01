class Auth::AuthPayload < ApplicationPayload
  def self.create(obj)
    auth_data(attr: {
                access_token: obj.access_token,
                refresh_token: obj.refresh_token,
                me: UserSerializer.call(obj.user)[:data]
              })
  end

  def self.auth_data(attr: nil, meta: nil)
    data = {
      data: {
        type: 'auth'
      }
    }
    data[:data][:meta] = meta if meta
    data[:data][:attributes] = attr if attr
    data
  end
end
