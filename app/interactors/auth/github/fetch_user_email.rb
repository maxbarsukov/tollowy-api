class Auth::Github::FetchUserEmail
  include Interactor

  delegate :github_access_token, to: :context

  def call
    response = GithubAdapter.new(github_access_token).user_emails
    context.fail!(error_data: response.error_data) unless response.success?

    context.email = sorted_email(response.emails).email
  end

  private

  # Sort by verified first, then by primary
  def sorted_email(emails)
    emails.min_by { |email| [email.verified ? 0 : 1, email.primary ? 0 : 1] }
  end
end
