class Auth::RemoveOldPossessionToken
  include Interactor

  def call
    context.old_token.destroy!
  end
end
