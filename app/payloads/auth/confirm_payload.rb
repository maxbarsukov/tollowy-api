class Auth::ConfirmPayload < ApplicationPayload
  def self.create(obj)
    {
      data: {
        me: UserSerializer.call(obj.user)[:data]
      }
    }
  end
end
