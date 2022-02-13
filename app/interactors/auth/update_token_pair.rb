class Auth::UpdateTokenPair
  include Interactor::Organizer
  include Concerns::TransactionalInteractor

  organize  ValidateRefreshToken,
            CreateAccessToken,
            CreateRefreshToken
end
