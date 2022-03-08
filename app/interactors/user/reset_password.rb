class User::ResetPassword
  include Interactor::Organizer
  include TransactionalInteractor

  delegate :user, to: :context

  organize User::FindByResetToken,
           User::UpdatePassword,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_reset_password)
  end
end
