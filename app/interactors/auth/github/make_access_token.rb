class Auth::Github::MakeAccessToken
  include Interactor
  using StringCheckBase64

  delegate :github_token, to: :context

  def call
    context.github_access_token = "token #{github_token}"
  end
end
