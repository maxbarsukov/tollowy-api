class Post::GetFollowingPosts
  include Interactor

  delegate :current_user, to: :context

  def call
    posts = Post.where(id: tags_posts_ids | users_posts_ids)

    context.following_posts_exists = posts.present?
    context.posts = posts
  end

  private

  def tags_ids
    current_user.following_by_type(Tag::NAME, { model: Tag }).ids
  end

  def tags_posts_ids
    ActsAsTaggableOn::Tagging.where(tag_id: tags_ids).distinct.pluck(:taggable_id)
  end

  def users_posts_ids
    Post.where(user_id: current_user.following_by_type('User').pluck(:id)).ids
  end
end
