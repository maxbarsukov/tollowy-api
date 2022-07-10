class Post::Index
  include Interactor

  delegate :controller, :current_user, to: :context

  def call
    result = Post::Paginate.call(
      controller: controller,
      posts: Post.all,
      current_user: current_user
    )

    context.posts = result.posts
  end
end
