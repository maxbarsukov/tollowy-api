class Auth::Vk::SaveUser
  include Interactor

  delegate :new_email_passed, to: :context

  def call
    return if context.existing_user

    context.user.role = new_email_passed ? :unconfirmed : :user
    context.fail!(error_data:) unless context.user.save
  end

  private

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: context.user.errors.to_a
    )
  end
end
