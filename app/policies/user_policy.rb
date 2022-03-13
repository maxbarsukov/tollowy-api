class UserPolicy < ApplicationPolicy
  def update?
    user.at_least_a?(:moderator) || user.id == record.id
  end
end
