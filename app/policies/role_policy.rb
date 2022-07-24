class RolePolicy < ApplicationPolicy
  attr_reader :user, :user_to_update, :role

  def initialize(current_user, *args)
    @user = current_user
    @user_to_update, @role = *args
    @error_message = []
    @error_code = nil

    require_user_in_good_standing!
  end

  def destroy?
    @error_message << 'You cant remove your own role' unless user_not_the_same
    @error_message << 'You cant remove main user role' unless role_is_not_main
    @error_message << 'You cant destroy this role' unless can_destroy_user_role

    set_error_code!

    user_not_the_same && role_is_not_main && can_destroy_user_role
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def update?
    @error_message << "No such role: #{role}. Roles: #{Role::MAIN_ROLES.join(', ')}" unless main_role_exists
    @error_message << 'User must be at least a moderator' unless user_is_moderator
    @error_message << 'You cant update your own role' unless user_not_the_same
    @error_message << 'You cant assign role higher then yours' unless user_assigns_lower_role

    set_error_code!

    user_is_moderator &&
      user_assigns_lower_role &&
      main_role_exists &&
      user_not_the_same
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def set_error_code!
    @error_code = :forbidden unless @error_message.empty?
  end

  def role_is_not_main
    !(@role.resource_id.nil? && @role.resource_type.nil?)
  end

  def can_destroy_user_role # rubocop:disable Metrics/AbcSize
    return false if @role.resource_type?

    if @user.at_least_a?(:admin)
      return @user.role_value > @user_to_update.role_value if @user_to_update.at_least_a?(:admin)

      return true
    end

    if @role.resource_id.present?
      @user.roles.where(resource_type: @role.resource_type, resource_id: @role.resource_id)
           .or(@user.roles.where(resource_type: @role.resource_type, resource_id: nil))
    else
      @user.roles.where(resource_type: @role.resource_type, resource_id: nil)
    end.any? { |r| r.value > @role.value }
  end

  def main_role_exists
    Role::MAIN_ROLES.include?(role.to_s)
  end

  def user_is_moderator
    @user_is_moderator = user.at_least_a?(:moderator)
  end

  def user_not_the_same
    @user_not_the_same = user.id != user_to_update.id
  end

  def user_assigns_lower_role
    @user_assigns_lower_role = user.dev? || (user.role.value > Role.value_for(role))
  end
end
