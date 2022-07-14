class Post::Create
  include Interactor

  delegate :post_params, :current_user, to: :context

  def call
    context.post = current_user.posts.new(post_params)

    fail! unless context.post.save
  end

  private

  def fail!
    context.fail!(error_data:)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: context.post.errors.to_a
    )
  end
end
