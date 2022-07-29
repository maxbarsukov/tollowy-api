class AuthMailer < ApplicationMailer
  def password_recovery(user)
    @title = I18n.t('mailers.auth.password_recovery.title')
    @user = user

    @password_recovery_link = format(
      ApplicationConfig['PASSWORD_RECOVERY_LINK_TEMPLATE'],
      password_reset_token: user.password_reset_token
    )

    mail(to: user.email, subject: "#{@title} | Followy")
  end

  def confirm_user(possession_token, options = {})
    action = options[:new_user] ? 'welcome' : 'confirm_user'
    @title = I18n.t("mailers.auth.#{action}.title")
    @user = possession_token.user

    @confirmation_link = format(
      ApplicationConfig['CONFIRM_USER_LINK_TEMPLATE'],
      token_value: possession_token.value
    )

    mail(to: @user.email, subject: "#{@title} | Followy", template_name: action)
  end
end
