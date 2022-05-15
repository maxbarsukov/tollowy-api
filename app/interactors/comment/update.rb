class Comment::Update
  include Interactor

  delegate :comment_params, :comment, to: :context

  def call
    context.fail!(error_data: error_data) unless update_comment_form.valid? && update_comment
  end

  private

  def update_comment
    comment.update(update_comment_form.model_attributes)
  end

  def update_comment_form
    @update_comment_form ||= UpdateCommentForm.new(comment).assign_attributes(comment_params)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: comment.errors.to_a + update_comment_form.errors.to_a
    )
  end
end
