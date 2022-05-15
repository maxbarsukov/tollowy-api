class Comment::Payload < ApplicationPayload
  def self.create(obj)
    CommentSerializer.call(obj.comment)
  end
end
