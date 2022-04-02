class RolePolicy < ApplicationPolicy
  attr_reader :user, :user_to_update, :role

  def initialize(current_user, *args)
    @user = current_user
    @user_to_update, @role = *args
    @error_message = []
    @error_code = nil

    require_user_in_good_standing!
  end

  def update?
    @error_message << 'User must be at least a moderator' unless user_is_moderator
    @error_message << 'You cant update your own role' unless user_not_the_same
    @error_message << 'You cant assign role higher then yours' unless user_assigns_lower_role

    @error_code = :forbidden unless @error_message.empty?

    user_is_moderator &&
      user_assigns_lower_role &&
      user_not_the_same
  end

  private

  def user_is_moderator
    @user_is_moderator = user.at_least_a?(:moderator)
  end

  def user_not_the_same
    @user_not_the_same = user.id != user_to_update.id
  end

  def user_assigns_lower_role
    @user_assigns_lower_role = user.role.value > Role.value_for(role)
  end
end
