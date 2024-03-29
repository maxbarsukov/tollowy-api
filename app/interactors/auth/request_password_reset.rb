class Auth::RequestPasswordReset
  include Interactor
  include TransactionalInteractor

  delegate :email, to: :context

  def call
    user ? generate_password_reset_token : raise_error
  end

  after do
    AuthMailer.password_recovery(user).deliver_later
    Events::CreateUserEventJob.perform_later(user.id, :reset_password_requested)
  end

  private

  def user
    @user ||= User.find_by(email:)
  end

  def generate_password_reset_token
    user.regenerate_password_reset_token
    user.password_reset_sent_at = Time.current
    user.save!
  end

  def raise_error
    context.fail!(error_data:)
  end

  def error_data
    ErrorData.new(
      status: 404,
      code: :not_found,
      title: I18n.t('api.auth.request_password_reset.not_found.message'),
      detail: I18n.t('api.auth.request_password_reset.not_found.detail', email:)
    )
  end
end
