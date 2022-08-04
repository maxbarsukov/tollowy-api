class User::NotifyIfNewIp
  include Interactor

  delegate :new_ip, :user, :request, to: :context

  def call
    return unless new_ip

    response = Geocoder.search(request.remote_ip).first.data
    UserMailer.new_ip_sign_in(user, request.remote_ip, geolocation(response)).deliver_later if context.new_ip
  end

  private

  def geolocation(response)
    if response.present? && response['country'].present? && response['city'].present?
      "#{response['country']}, #{response['city']}"
    else
      I18n.t('other.geocoder.cant_find_location')
    end
  end
end
