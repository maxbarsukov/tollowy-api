class Auth::SignIn
  include Interactor::Organizer

  delegate :user, to: :context

  organize User::AuthenticateByEmailAndPassword,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken

  after do
    RegisterActivityJob.perform_later(user.id, :user_logged_in)
  end
end
