class Auth::SignUp
  include Interactor::Organizer
  include TransactionalInteractor

  delegate :user, to: :context

  organize User::Create,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           Auth::CreatePossessionToken,
           User::UpdateTrackableData

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_registered)
    AuthMailer.confirm_user(context.possession_token, new_user: true).deliver_later
  end
end
