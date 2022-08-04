class Auth::SignIn
  include Interactor::Organizer

  delegate :user, :request, to: :context

  organize User::AuthenticateByCredentials,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           User::UpdateTrackableData,
           User::RegisterIpAddress,
           User::NotifyIfNewIp

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in)
  end
end
