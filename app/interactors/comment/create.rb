class Comment::Create
  include Interactor

  delegate :comment_params, :current_user, to: :context

  def call
    context.comment = Comment.new(comment_params.merge(user: current_user))

    fail! unless context.comment.save
  end

  private

  def fail!
    context.fail!(error_data: error_data)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: context.comment.errors.to_a
    )
  end
end
