class Auth::ResendConfirm
  include Interactor::Organizer
  include TransactionalInteractor

  delegate :possession_token, to: :context

  organize Auth::CheckTimePassed,
           Auth::RemoveOldPossessionToken,
           Auth::CreatePossessionToken

  after do
    AuthMailer.confirm_user(context.possession_token).deliver_later
  end
end
