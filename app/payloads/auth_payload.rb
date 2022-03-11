class AuthPayload < ApplicationPayload
  def self.create(obj)
    {
      access_token: obj.access_token,
      refresh_token: obj.refresh_token,
      me: UserSerializer.new(obj.user)
    }
  end
end
