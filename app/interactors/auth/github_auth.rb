class Auth::GithubAuth
  include Interactor::Organizer

  delegate :user, :login_by_existing_email, to: :context

  organize Auth::Github::DecodeToken,
           Auth::Github::MakeAccessToken,
           Auth::Github::FetchUserData,
           Auth::Github::FetchUserEmail,
           Auth::Github::CheckExistingUser,
           Auth::Github::CheckExistingEmailUser,
           Auth::Github::CreateUser,
           Auth::Github::SaveUser,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           Auth::CreatePossessionToken,
           User::UpdateTrackableData,
           Auth::Providers::AddMessage,
           Auth::Providers::SetHttpStatus

  after do
    AuthMailer.confirm_user(context.possession_token).deliver_later if login_by_existing_email
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in_with_provider, 'GitHub')
  end
end
