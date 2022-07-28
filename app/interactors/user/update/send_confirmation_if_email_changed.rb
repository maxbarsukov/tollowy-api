class User::Update::SendConfirmationIfEmailChanged
  include Interactor

  delegate :email_changed, :user, :current_user, to: :context

  def call
    return if !email_changed || another_user?

    user.make_unconfirmed!
    send_mail!
    add_message!
  end

  private

  def send_mail!
    possession_token = Auth::CreatePossessionToken.call(user:).possession_token
    AuthMailer.confirm_user(possession_token).deliver_later
  end

  def add_message!
    context.message = I18n.t('user.update.email_changed', email: user.email)
  end

  def another_user?
    current_user.id != user.id
  end
end
