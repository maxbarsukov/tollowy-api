class User::IndexPayload < ApplicationPayload
  def self.create(obj)
    {
      **UserSerializer.call(obj.collection),
      links: obj.links,
      meta: obj.meta
    }
  end
end
