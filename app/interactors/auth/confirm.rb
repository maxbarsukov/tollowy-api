class Auth::Confirm
  include Interactor::Organizer
  include TransactionalInteractor

  organize Auth::Confirm::GetToken,
           Auth::Confirm::CheckTokenTtl,
           Auth::Confirm::UpdateUser,
           Auth::Confirm::DestroyToken
end
