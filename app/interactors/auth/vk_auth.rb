class Auth::VkAuth
  include Interactor::Organizer

  delegate :user, :new_email_passed, :login_by_existing_email, to: :context

  organize Auth::Vk::DecodeResponse,
           Auth::Vk::FetchUserData,
           Auth::Vk::CheckUserIdTraversal,
           Auth::Vk::CheckExistingUser,
           Auth::Vk::CheckEmailPassed,
           Auth::Vk::CheckExistingEmailUser,
           Auth::Vk::SetEmailContext,
           Auth::Vk::CreateUser,
           Auth::Vk::SaveUser,
           Auth::CreateAccessToken,
           Auth::CreateRefreshToken,
           Auth::CreatePossessionToken,
           User::UpdateTrackableData

  after do
    AuthMailer.confirm_user(context.possession_token).deliver_later if new_email_passed || login_by_existing_email
    Events::CreateUserEventJob.perform_later(user.id, :user_logged_in_with_provider, 'VK')
  end
end
