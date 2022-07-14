class User::UpdatePassword
  include Interactor

  delegate :password, :user, to: :context

  def call
    context.fail!(error_data:) unless update_user_password_form.valid? && update_user_password
  end

  private

  def update_user_password
    user.update(update_user_password_attributes)
  end

  def update_user_password_attributes
    update_user_password_form
      .model_attributes
      .merge(password_reset_token: nil, password_reset_sent_at: nil)
  end

  def update_user_password_form
    @update_user_password_form ||= UpdateUserPasswordForm.new(user).assign_attributes(password:)
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: update_user_password_form.errors.to_a
    )
  end
end
