class ApplicationSerializer
  include JSONAPI::Serializer

  class << self
    alias call new
  end
end
