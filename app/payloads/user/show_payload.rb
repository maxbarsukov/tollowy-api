class User::ShowPayload < Tag::Payload
  def self.create(obj)
    UserSerializer.call(obj.user)
  end
end
