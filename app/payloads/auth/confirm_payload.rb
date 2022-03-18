class Auth::ConfirmPayload < ApplicationPayload
  def self.create(obj)
    {
      me: UserSerializer.call(obj.user)[:data]
    }
  end
end
