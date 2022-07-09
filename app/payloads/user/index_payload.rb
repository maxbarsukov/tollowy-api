class User::IndexPayload < ApplicationPayload
  def self.create(obj)
    {
      **UserSerializer.call(obj.users.collection, { params: obj.options }),
      links: obj.users.links,
      meta: obj.users.meta
    }
  end
end
