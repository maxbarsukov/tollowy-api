class Tag::Payload < ApplicationPayload
  def self.create(obj)
    TagSerializer.call(obj.tag)
  end
end
