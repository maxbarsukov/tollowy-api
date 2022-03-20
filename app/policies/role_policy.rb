class RolePolicy < ApplicationPolicy
  attr_reader :user, :user_to_update, :role

  def initialize(current_user, *args)
    @user = current_user
    @user_to_update, @role = *args

    require_user_in_good_standing!
  end

  def update?
    user.at_least_a?(:moderator) &&
      user.role.value > Role.value_for(role) &&
      user.id != user_to_update.id
  end
end
