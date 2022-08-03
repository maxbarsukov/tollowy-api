class Auth::ResendConfirm::CheckTimePassed
  include Interactor

  delegate :current_user, to: :context

  def call
    context.fail!(error_data: unauthorized) if current_user.blank?
    context.fail!(error_data: no_confirmations_sent) if token.blank?
    context.fail!(error_data: time_not_passed) unless enough_time_passed?

    context.user = current_user
    context.old_token = token
  end

  private

  def enough_time_passed? = time_passed_since_last_mail >= 1.minute

  def time_passed_since_last_mail = Time.current - token.created_at

  def seconds_to_wait = 60 - time_passed_since_last_mail.round

  def token
    return @token if defined? @token

    @token ||= current_user.possession_tokens.order(created_at: :desc).first
  end

  def time_not_passed
    ErrorData.new(
      status: 403,
      code: :forbidden,
      title: I18n.t('api.auth.resend_confirm.errors.time_not_passed.message', seconds_to_wait:)
    )
  end

  def unauthorized
    ErrorData.new(
      status: 401,
      code: :unauthorized,
      title: I18n.t('api.auth.resend_confirm.errors.unauthorized.message')
    )
  end

  def no_confirmations_sent
    ErrorData.new(
      status: 409,
      code: :conflict,
      title: I18n.t('api.auth.resend_confirm.errors.no_confirmations_sent.message')
    )
  end
end
