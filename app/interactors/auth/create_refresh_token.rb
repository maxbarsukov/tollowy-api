class Auth::CreateRefreshToken
  include Interactor

  REFRESH_TOKEN_TTL = 30.days

  delegate :user, :jti, to: :context

  def call
    create_refresh_token!
    context.refresh_token = refresh_token
  end

  private

  def create_refresh_token!
    RefreshToken.create!(
      user_id: user.id,
      expires_at: REFRESH_TOKEN_TTL.from_now,
      token: refresh_token,
      jti:
    )
  end

  def refresh_token
    @refresh_token ||= JWT.encode(payload, ApplicationConfig['JWT_SECRET_TOKEN'], 'HS256')
  end

  def payload
    {
      sub: user.id,
      exp: REFRESH_TOKEN_TTL.from_now.to_i,
      jti:,
      type: 'refresh'
    }
  end
end
