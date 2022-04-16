class PostPolicy < ApplicationPolicy
  def update?
    manage?
  end

  def destroy?
    manage?
  end

  private

  def manage?
    require_user_in_good_standing!

    user.admin? ||
      user.id == record.user_id ||
      user.is_owner_of?(record) ||
      user.is_moderator_of?(record) ||
      user.is_moderator_of?(Post)
  end
end
