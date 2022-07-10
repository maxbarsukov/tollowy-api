class User::IndexPayload < ApplicationPayload
  def self.create(obj)
    {
      **UserSerializer.call(obj.users.collection),
      links: obj.users.links,
      meta: obj.users.meta
    }
  end
end
