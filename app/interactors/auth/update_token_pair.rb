class Auth::UpdateTokenPair
  include Interactor::Organizer
  include TransactionalInteractor

  organize  ValidateRefreshToken,
            CreateAccessToken,
            CreateRefreshToken
end
