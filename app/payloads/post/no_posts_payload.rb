class Post::NoPostsPayload < Post::Payload
  def self.create(_obj)
    {
      data: {
        type: 'post',
        meta: {
          message: 'You have no posts in your feed'
        }
      }
    }
  end
end
