class Post::IndexPayload < Post::Payload
  def self.create(obj)
    {
      **PostSerializer.call(obj.posts.collection, { params: obj.options }),
      links: obj.posts.links,
      meta: obj.posts.meta
    }
  end
end
