class User::ShowPayload < ApplicationPayload
  def self.create(obj)
    UserSerializer.call(obj.user)
  end
end
