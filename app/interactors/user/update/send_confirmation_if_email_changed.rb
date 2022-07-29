class User::Update::SendConfirmationIfEmailChanged
  include Interactor

  delegate :email_changed, :user, :current_user, to: :context

  def call
    context.is_another_user = another_user?
    return if !email_changed || another_user?

    user.make_unconfirmed!
    send_mail!
  end

  private

  def send_mail!
    possession_token = Auth::CreatePossessionToken.call(user:).possession_token
    AuthMailer.confirm_user(possession_token).deliver_later
  end

  def another_user?
    current_user.id != user.id
  end
end
