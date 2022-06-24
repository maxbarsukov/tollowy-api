class Post::ShowPayload < Post::Payload
  def self.create(obj)
    PostSerializer.call(obj.post, { params: { my_rate: obj.my_rate } })
  end
end
