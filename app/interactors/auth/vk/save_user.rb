class Auth::Vk::SaveUser
  include Interactor

  delegate :need_to_confirm, to: :context

  def call
    return if context.existing_user

    context.user.role = need_to_confirm ? :unconfirmed : :user
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
