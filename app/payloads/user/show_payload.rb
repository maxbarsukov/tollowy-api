class User::ShowPayload < Tag::Payload
  def self.create(obj)
    UserSerializer.call(obj.user, { params: obj.options })
  end
end
