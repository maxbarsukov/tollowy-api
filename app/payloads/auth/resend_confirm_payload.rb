class Auth::ResendConfirmPayload < Auth::AuthPayload
  def self.create(_obj)
    auth_data(meta: { message: I18n.t('api.auth.resend_confirm.sent.message') })
  end
end
