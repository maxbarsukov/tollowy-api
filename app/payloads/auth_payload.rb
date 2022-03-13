class AuthPayload < ApplicationPayload
  def self.create(obj)
    {
      access_token: obj.access_token,
      refresh_token: obj.refresh_token,
      me: UserSerializer.call(obj.user)
    }
  end
end
