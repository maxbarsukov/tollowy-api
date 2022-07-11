class User::UpdateAttributes
  include Interactor

  delegate :user_params, :user, to: :context

  def call
    context.fail!(error_data: error_data) unless update_user_form.valid? && update_user
  end

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_updated)
  end

  private

  def update_user
    user.update(update_user_form.model_attributes)
  end

  def update_user_form
    @update_user_form ||= UpdateUserForm.new(user).assign_attributes(user_params)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: user.errors.to_a + update_user_form.errors.to_a
    )
  end
end
