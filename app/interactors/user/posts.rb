class User::Posts
  include Interactor

  delegate :controller, :user, :current_user, to: :context

  def call
    result = Post::Paginate.call(
      controller: controller,
      posts: user.posts,
      current_user: current_user
    )

    context.posts = result.posts
    context.options = result.options
  end
end
