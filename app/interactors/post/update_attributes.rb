class Post::UpdateAttributes
  include Interactor

  delegate :post_params, :post, to: :context

  def call
    context.fail!(error_data:) unless update_post_form.valid? && update_post
  end

  private

  def update_post
    post.update(update_post_form.model_attributes)
  end

  def update_post_form
    @update_post_form ||= UpdatePostForm.new(post).assign_attributes(post_params)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: post.errors.to_a + update_post_form.errors.to_a
    )
  end
end
