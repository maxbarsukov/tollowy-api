class Post::ShowPayload < Post::Payload
  def self.create(obj)
    PostSerializer.call(obj.post)
  end
end
