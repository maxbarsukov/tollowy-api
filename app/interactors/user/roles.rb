class User::Roles
  include Interactor::Organizer

  delegate :controller, :user, to: :context

  def call
    roles = user.roles.where(resource_id: nil).or(
      user.roles.where(resource_type: Role::PUBLIC_RESOURCES)
    ).order('resource_id DESC NULLS FIRST, resource_type DESC NULLS FIRST')

    paginated = controller.send(:paginate, roles, controller.send(:pagination_params))
    context.roles = paginated
  end
end
