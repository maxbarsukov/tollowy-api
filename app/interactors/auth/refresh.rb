class Auth::Refresh
  include Interactor::Organizer
  include TransactionalInteractor

  organize  Auth::Refresh::ValidateRefreshToken,
            Auth::CreateAccessToken,
            Auth::CreateRefreshToken
end
