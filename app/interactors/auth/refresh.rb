class Auth::Refresh
  include Interactor::Organizer
  include TransactionalInteractor

  organize  Auth::ValidateRefreshToken,
            Auth::CreateAccessToken,
            Auth::CreateRefreshToken
end
