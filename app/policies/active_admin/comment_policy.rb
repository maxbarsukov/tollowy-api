# frozen_string_literal: true

class ActiveAdmin::CommentPolicy < Admin::ApplicationPolicy
  def destroy?
    record.author_id == user.id
  end
end
