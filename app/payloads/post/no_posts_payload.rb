class Post::NoPostsPayload < Post::Payload
  def self.create(_obj)
    {
      data: [],
      links: {},
      meta: {
        total: 0,
        pages: 0,
        message: 'You have no posts in your feed'
      }
    }
  end
end
