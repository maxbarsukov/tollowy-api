class Auth::RequestPasswordResetPayload < Auth::AuthPayload
  def self.create(_obj)
    auth_data(
      meta: {
        message: I18n.t('api.auth.request_password_reset.sent.message'),
        detail: I18n.t('api.auth.request_password_reset.sent.detail')
      }
    )
  end
end
