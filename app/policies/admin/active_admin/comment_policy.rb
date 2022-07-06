# frozen_string_literal: true

class Admin::ActiveAdmin::CommentPolicy < Admin::ApplicationPolicy
  def destroy?
    record.author_id == user.id
  end
end
