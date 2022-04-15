class Post::Payload < ApplicationPayload
  def self.create(obj)
    PostSerializer.call(obj.post)
  end
end
