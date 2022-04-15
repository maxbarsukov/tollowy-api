class Admin::PostPolicy < Admin::ApplicationPolicy
  def update?
    manage? && super
  end

  def destroy?
    manage? && super
  end

  private

  def manage?
    record.user.role.value < user.role.value || record.user_id == user.id
  end
end
