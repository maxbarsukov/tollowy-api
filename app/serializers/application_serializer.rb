class ApplicationSerializer
  include JSONAPI::Serializer

  class << self
    alias call new
  end

  delegate :[], to: :serializable_hash
end
