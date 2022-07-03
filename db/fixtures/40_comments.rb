class CommentFixture < ApplicationFixture
  seed do
    comments = []

    Post.take(20).each do |post|
      u = User.order('RANDOM()').first
      c = post.comments.new(
        body: "Comment to post №#{post.id}",
        user: u,
        commentable_type: 'Post', commentable_id: post.id
      )
      puts "#{post.id}:\tComment(body: #{c.body}, post: #{c.commentable_id}, user: #{c.user_id})"
      comments << c
    end

    import comments
  end
end
