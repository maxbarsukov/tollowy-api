class Auth::UpdateTokenPair
  include Interactor::Organizer
  include TransactionalInteractor

  organize  Auth::ValidateRefreshToken,
            Auth::CreateAccessToken,
            Auth::CreateRefreshToken
end
