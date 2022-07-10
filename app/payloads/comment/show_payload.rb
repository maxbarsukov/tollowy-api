class Comment::ShowPayload < Comment::Payload
  def self.create(obj)
    CommentSerializer.call(obj.comment)
  end
end
