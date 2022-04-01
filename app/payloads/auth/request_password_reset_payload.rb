class Auth::RequestPasswordResetPayload < Auth::AuthPayload
  def self.create(_obj)
    auth_data(
      meta: {
        message: I18n.t('password_recovery.sent.message'),
        detail: I18n.t('password_recovery.sent.detail')
      }
    )
  end
end
