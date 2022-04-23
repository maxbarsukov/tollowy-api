class Post::IndexPayload < Post::Payload
  def self.create(obj)
    {
      **PostSerializer.call(obj.collection),
      links: obj.links,
      meta: obj.meta
    }
  end
end
