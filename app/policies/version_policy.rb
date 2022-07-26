class VersionPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
    @error_message = []
    @error_code = nil
  end

  def show?
    can_show?.tap do |result|
      @error_code = :forbidden
      @error_message << 'You have not permissions to see this version' unless result
    end
  end

  def create? = manage?

  def update? = manage?

  def destroy? = manage?

  private

  def can_show?
    return true if record.for_role == 'all'
    return false if user.blank? || user.role.name.blank?

    Version::ROLES_HIERARCHY[user.role.name.to_s].include?(record.for_role)
  end

  def manage?
    require_user_in_good_standing!

    @error_code = :forbidden
    user.dev?.tap do |result|
      @error_message << 'You must be developer to manage versions' unless result
    end
  end
end
