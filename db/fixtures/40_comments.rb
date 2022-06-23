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
    load_answers comments
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def load_answers(comments)
    post = comments[0].commentable
    3.times do |t|
      u = User.order('RANDOM()').first
      c = comments[0].children.create!(
        user: u,
        body: "Answer #{t} to first comment",
        commentable_type: 'Post', commentable_id: post.id
      )
      puts "- #{c.id}:\tAnswer to first comment"
    end

    comments[0].children[0].children.create!(
      user: User.order('RANDOM()').first,
      body: 'Answer to answer to first comment',
      commentable_type: 'Post', commentable_id: post.id
    )
    puts "- - 1:\tAnswer to answer to first comment"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
