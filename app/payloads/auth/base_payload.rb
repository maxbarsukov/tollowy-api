class Auth::BasePayload < ApplicationPayload
  def self.create(obj)
    {
      data: {
        access_token: obj.access_token,
        refresh_token: obj.refresh_token,
        me: UserSerializer.call(obj.user)[:data]
      }
    }
  end
end
