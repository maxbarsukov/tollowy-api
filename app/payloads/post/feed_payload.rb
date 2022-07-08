class Post::FeedPayload < Post::Payload
  def self.create(obj)
    return Post::NoPostsPayload.create(obj) unless obj.following_posts_exists

    Post::IndexPayload.create(obj)
  end
end
