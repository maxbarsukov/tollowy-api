class Auth::VkAuth
  include Interactor::Organizer

  delegate :user, :need_to_confirm, to: :context

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
    AuthMailer.confirm_user(context.possession_token).deliver_later if need_to_confirm
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in_with_provider)
  end
end
