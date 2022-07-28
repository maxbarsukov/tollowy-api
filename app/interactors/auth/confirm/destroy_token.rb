class Auth::Confirm::DestroyToken
  include Interactor

  delegate :token, to: :context

  def call
    token.destroy!
  end
end
