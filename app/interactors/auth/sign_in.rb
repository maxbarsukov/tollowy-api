class Auth::SignIn
  include Interactor::Organizer

  delegate :user, to: :context

  organize User::AuthenticateByCredentials,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           User::UpdateTrackableData

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in)
  end
end
