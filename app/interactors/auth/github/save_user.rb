class Auth::Github::SaveUser
  include Interactor

  def call
    return if context.existing_user

    context.user.role = :user
    context.fail!(error_data:) unless context.user.save

    context.user.providers.create!(name: 'github', uid: context.user_response.id)
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
