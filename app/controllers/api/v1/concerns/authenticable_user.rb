module Api::V1::Concerns::AuthenticableUser
  extend ActiveSupport::Concern

  private

  def current_user
    return unless token && payload && active_refresh_token?

    User.find_by(id: payload['sub'])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    raise UnauthenticatedError unless user_signed_in?
  end

  def token
    @token ||= request.headers['Authorization'].to_s.match(/Bearer (.*)/).to_a.last
  end

  def payload
    @payload ||= JWT.decode(
      token,
      ApplicationConfig['JWT_SECRET_TOKEN'],
      true,
      algorithm: 'HS256'
    ).first
  rescue JWT::DecodeError
    {}
  end

  def jti
    payload['jti']
  end

  def active_refresh_token?
    RefreshToken.active.exists?(jti: jti)
  end
end
