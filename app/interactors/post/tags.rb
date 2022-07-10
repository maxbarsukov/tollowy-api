class Post::Tags
  include Interactor

  delegate :controller, :post, :current_user, to: :context

  def call
    result = Tag::Index.call(
      controller: controller,
      tags: post.tags,
      current_user: current_user
    )

    context.tags = result.tags
  end
end
