class User::Comments
  include Interactor

  delegate :controller, :user, :current_user, to: :context

  def call
    result = Comment::Paginate.call(
      controller: controller,
      comments: user.comments,
      current_user: current_user
    )

    context.comments = result.comments
  end
end
