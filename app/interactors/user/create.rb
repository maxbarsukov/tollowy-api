class User::Create
  include Interactor

  delegate :user_params, to: :context

  def call
    context.user = User.new(user_params)
    context.user.add_role(:unconfirmed)

    context.fail!(error_data: error_data) unless context.user.save
  end

  private

  def error_data
    {
      status: 422,
      code: :unprocessable_entity,
      title: 'Record Invalid',
      detail: context.user.errors.to_a
    }
  end
end
