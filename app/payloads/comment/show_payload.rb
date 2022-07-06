class Comment::ShowPayload < Comment::Payload
  def self.create(obj)
    CommentSerializer.call(obj.comment, { params: { my_rate: obj.my_rate } })
  end
end
