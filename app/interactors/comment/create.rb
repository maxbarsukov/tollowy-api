class Comment::Create
  include Interactor

  delegate :comment_params, :current_user, to: :context

  def call
    update_params!
    validate_parent_id!

    context.comment = Comment.new(comment_params)

    fail! unless context.comment.save
  end

  private

  def update_params!
    context.comment_params[:user] = current_user
    return unless !comment_params.key?(:commentable_id) && comment_params.key?(:parent_id)

    comment_params.merge!(commentable_id: Comment.find(comment_params[:parent_id]).commentable_id)
  end

  def validate_parent_id!
    return unless comment_params[:parent_id] && (
      Comment.find(comment_params[:parent_id]).commentable_id.to_s != comment_params[:commentable_id].to_s
    )

    context.fail!(error_data: ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Invalid Parameter',
      detail: 'Own commentable_id and parent commentable_id are not the same'
    ))
  end

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
