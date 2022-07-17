class UserDecorator < ApplicationDecorator
  delegate_all

  def provider_id = "#{object.provider}-#{object.read_attribute(:provider_uid) || object.id.to_s}"
end
