class Tag::ShowPayload < Tag::Payload
  def self.create(obj)
    TagSerializer.call(obj.tag)
  end
end
