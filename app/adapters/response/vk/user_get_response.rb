class Response::Vk::UserGetResponse < Response::Github::Response
  ATTRIBUTES = %i[
    id nickname city country about site status screen_name first_name last_name
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(attrs)
    attrs[:response][0].each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
