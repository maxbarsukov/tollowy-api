class Tag::ShowPayload < Tag::Payload
  def self.create(obj)
    TagSerializer.call(obj.tag, { params: obj.options })
  end
end
