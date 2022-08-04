class User::RegisterIpAddress
  include Interactor

  delegate :user, :request, to: :context

  def call
    context.fail!(error_data: invalid_user) if user.new_record? || user.blank?

    if ip_belongs_to_current_user?
      address = find_current_user_address
      address.user_sign_in_count += 1
    else
      context.new_ip = true
      address = user.ip_addresses.new(ip: current_ip, user_sign_in_count: 1)
    end

    context.fail!(error_data: invalid_ip_address) unless address.save
  end

  private

  def current_ip = request.remote_ip

  def ip_belongs_to_current_user? = find_current_user_address.present?

  def find_current_user_address
    return @find_current_user_address if defined? @find_current_user_address

    @find_current_user_address = user.ip_addresses.get_by_ip(current_ip)
  end

  def invalid_user = error_data('Invalid user')

  def invalid_ip_address = error_data('Invalid IP address')

  def error_data(title)
    ErrorData.new(status: 422, code: :unprocessable_entity, title:)
  end
end
