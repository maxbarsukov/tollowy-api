class Comment::Destroy
  include Interactor

  delegate :comment, to: :context

  def call
    comment.destroy
    fail! unless comment.destroyed?
  end

  private

  def fail!
    context.fail!(error_data: error_data)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: "Can't destroy comment",
      detail: context.comment.errors.to_a
    )
  end
end
