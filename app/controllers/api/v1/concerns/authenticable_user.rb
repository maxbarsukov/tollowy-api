module Api::V1::Concerns::AuthenticableUser
  extend ActiveSupport::Concern

  private

  def current_user
    puts 'HERE ==================== current_user'
    puts !!token
    puts !!jwt_payload
    puts !!active_refresh_token?
    puts token && jwt_payload && active_refresh_token?

    return unless token && jwt_payload && active_refresh_token?

    User.find_by(id: jwt_payload['sub'])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    raise Auth::UnauthenticatedError unless user_signed_in?
  end

  def token
    @token ||= request.headers['Authorization'].to_s.match(/Bearer (.*)/).to_a.last
  end

  def jwt_payload
    @jwt_payload ||= JWT.decode(
      token,
      ApplicationConfig['JWT_SECRET_TOKEN'],
      true,
      algorithm: 'HS256'
    ).first
  rescue JWT::DecodeError
    {}
  end

  def jti
    jwt_payload['jti']
  end

  def active_refresh_token?
    RefreshToken.active.exists?(jti: jti)
  end
end
