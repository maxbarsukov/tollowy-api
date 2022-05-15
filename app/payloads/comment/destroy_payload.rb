class Comment::DestroyPayload < Comment::Payload
  def self.create(_obj)
    {
      data: {
        type: 'comment',
        meta: {
          message: 'Comment successfully destroyed'
        }
      }
    }
  end
end
