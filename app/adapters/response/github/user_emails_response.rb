class Response::Github::UserEmailsResponse < Response::Github::Response
  attr_accessor :emails

  def initialize(attrs)
    @emails = []
    attrs.each do |email_hash|
      email = Response::Github::Models::Email.new(email_hash)
      @emails << email unless email.github_email?
    end
  end
end
