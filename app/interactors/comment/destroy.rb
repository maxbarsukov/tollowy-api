class Comment::Destroy
  include Interactor

  delegate :comment, to: :context

  def call
    if comment.is_childless?
      fail! unless comment.destroy
    else
      comment.deleted = true
    end

    fail! unless comment.save
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
