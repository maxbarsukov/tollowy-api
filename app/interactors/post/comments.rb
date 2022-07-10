class Post::Comments
  include Interactor

  delegate :controller, :post, :current_user, to: :context

  def call
    result = Comment::Paginate.call(
      controller: controller,
      comments: post.comments,
      current_user: current_user
    )

    context.comments = result.comments
  end
end
