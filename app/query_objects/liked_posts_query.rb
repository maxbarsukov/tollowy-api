class LikedPostsQuery
  attr_reader :posts, :current_user_id

  def initialize(posts, current_user)
    @posts = posts
    @current_user_id = current_user.id
  end

  def call
    posts
      .joins(
        Post.sanitize_sql_array(
          [
            'JOIN users ON users.id = ? LEFT JOIN votes ON votes.votable_id = posts.id AND votes.voter_id = ?',
            current_user_id, current_user_id
          ]
        )
      )
      .select(
        '"posts".* AS posts_data, CASE votes.vote_flag WHEN TRUE THEN 1 WHEN FALSE THEN -1 ELSE 0 END AS my_rate'
      )
      .group('my_rate, posts.id')
  end
end
