class User::Update
  include Interactor::Organizer
  include TransactionalInteractor

  organize User::Update::CheckEmailUpdate,
           User::Update::UpdateAttributes,
           User::Update::SendConfirmationIfEmailChanged,
           User::Update::AddMessage,
           User::SetAmIFollow
end
