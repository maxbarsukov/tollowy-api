class Auth::SignUp
  include Interactor::Organizer
  include Concerns::TransactionalInteractor

  delegate :user, to: :context

  organize User::Create,
           CreateAccessToken,
           CreateRefreshToken,
           CreatePossessionToken

  after do
    RegisterActivityJob.perform_later(user.id, :user_registered)
    AuthMailer.confirm_user(context.possession_token).deliver_later
  end
end
