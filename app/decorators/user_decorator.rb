class UserDecorator < ApplicationDecorator
  delegate_all

  def role
    roles.global.first
  end
end
