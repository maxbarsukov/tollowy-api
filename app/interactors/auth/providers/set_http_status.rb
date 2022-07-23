class Auth::Providers::SetHttpStatus
  include Interactor

  delegate :existing_user, to: :context

  def call
    context.http_status = existing_user ? :ok : :created
  end
end
