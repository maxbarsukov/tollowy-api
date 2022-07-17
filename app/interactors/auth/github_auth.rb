class Auth::GithubAuth
  include Interactor::Organizer

  delegate :user, to: :context

  organize Auth::Github::DecodeToken,
           Auth::Github::MakeAccessToken,
           Auth::Github::FetchUserData,
           Auth::Github::CreateOrFindUser,
           Auth::Github::FetchUserEmail,
           Auth::Github::SaveUser,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           User::UpdateTrackableData

  after do
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in_with_provider)
  end
end
