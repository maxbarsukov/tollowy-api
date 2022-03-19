class RolePolicy < ApplicationPolicy
  attr_reader :current_user, :user, :role

  def initialize(current_user, *args)
    @current_user = current_user
    @user, @role = *args
  end

  def update?
    current_user.at_least_a?(:moderator) &&
      current_user.role.value > Role.value_for(role) &&
      current_user.id != user.id
  end
end
