class Auth::VkAuth
  include Interactor::Organizer

  delegate :user, :new_email_passed, to: :context

  organize Auth::Vk::DecodeResponse,
           Auth::Vk::SetContext,
           # Auth::Vk::CheckExistingEmailUser,
           Auth::Vk::FetchUserData,
           Auth::Vk::CreateOrFindUser,
           Auth::Vk::SaveUser,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           Auth::CreatePossessionToken,
           User::UpdateTrackableData

  after do
    AuthMailer.confirm_user(context.possession_token).deliver_later if new_email_passed
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in_with_provider)
  end
end
