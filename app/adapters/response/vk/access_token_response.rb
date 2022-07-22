class Response::Vk::AccessTokenResponse < Response::Vk::Response
  ATTRIBUTES = %i[access_token user_id email].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(attrs)
    attrs.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
