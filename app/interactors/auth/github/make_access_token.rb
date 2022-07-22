class Auth::Github::MakeAccessToken
  include Interactor

  delegate :github_token, to: :context

  def call
    context.github_access_token = "token #{github_token}"
  end
end
