class Post::DestroyPayload < Post::Payload
  def self.create(_obj)
    {
      data: {
        type: 'post',
        meta: {
          message: 'Post successfully destroyed'
        }
      }
    }
  end
end
