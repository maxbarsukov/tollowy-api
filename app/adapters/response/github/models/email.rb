class Response::Github::Models::Email
  attr_accessor :email, :primary, :verified, :visibility

  def initialize(hash)
    @email = hash[:email]
    @primary = hash[:primary]
    @verified = hash[:verified]
    @visibility = hash[:visibility]
  end

  def github_email?
    @email.end_with?('github.com')
  end
end
