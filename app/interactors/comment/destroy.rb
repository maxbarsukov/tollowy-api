class Comment::Destroy
  include Interactor

  delegate :comment, to: :context

  def call
    if comment.is_childless?
      comment.destroy
      fail! unless comment.destroyed?
    else
      comment.deleted = true
      comment.body = 'DELETED'
      fail! unless comment.save
    end
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
