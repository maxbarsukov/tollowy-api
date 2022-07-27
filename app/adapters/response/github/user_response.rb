class Response::Github::UserResponse < Response::Github::Response
  ATTRIBUTES = %i[
    login id node_id avatar_url gravatar_id url html_url
    name company blog location email hireable bio twitter_username
    email
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(attrs)
    attrs.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
