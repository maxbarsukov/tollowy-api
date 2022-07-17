class Auth::Github::FetchUserEmail
  include Interactor

  delegate :existing_user, :user, :github_access_token, to: :context

  def call
    return if existing_user

    response = GithubAdapter.new(github_access_token).user_emails
    context.fail!(error_data: response.error_data) unless response.success?

    # Sort by verified first, then by primary
    main_email = response.emails.min_by { |email| [email.verified ? 0 : 1, email.primary ? 0 : 1] }
    context.user.email = main_email.email
  end
end
