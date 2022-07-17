class Auth::Github::FetchUserData
  include Interactor

  delegate :github_access_token, to: :context

  def call
    response = GithubAdapter.new(github_access_token).user
    context.fail!(error_data: response.error_data) unless response.success?

    context.user_response = response
  end
end
