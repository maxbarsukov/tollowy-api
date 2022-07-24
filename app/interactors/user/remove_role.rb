class User::RemoveRole
  include Interactor

  delegate :user, :role, to: :context

  def call
    fail! unless user.roles.exists?(role.id)

    resource = role.resource || role.resource_type.constantize
    user.remove_role(role.name.to_sym, resource)
  end

  private

  def fail! = context.fail!(error_data:)

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: "Can't remove role",
      detail: 'User does not have this role'
    )
  end
end
