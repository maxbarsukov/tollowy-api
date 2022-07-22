class ProviderDecorator < ApplicationDecorator
  delegate_all

  def provider_id = "#{object.name}-#{object.uid}"
end
