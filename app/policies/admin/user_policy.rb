class Admin::UserPolicy < Admin::ApplicationPolicy
  def update?
    (record.role.value < user.role.value || record.id == user.id) && super
  end

  def destroy?
    record.role.value < user.role.value &&
      record.id != user.id &&
      super
  end
end
