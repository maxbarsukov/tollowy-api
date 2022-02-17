class Auth::SignUp
  include Interactor::Organizer
  include TransactionalInteractor

  delegate :user, to: :context

  organize User::Create,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           Auth::CreatePossessionToken

  after do
    RegisterActivityJob.perform_later(user.id, :user_registered)
    AuthMailer.confirm_user(context.possession_token).deliver_later
  end
end
