class Auth::RequestPasswordResetPayload < ApplicationPayload
  def self.create(_obj)
    {
      data: {
        message: I18n.t('password_recovery.sent.message'),
        detail: I18n.t('password_recovery.sent.detail')
      }
    }
  end
end
