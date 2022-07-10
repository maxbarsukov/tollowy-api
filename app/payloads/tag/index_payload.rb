class Tag::IndexPayload < Tag::Payload
  def self.create(obj)
    {
      **TagSerializer.call(obj.tags.collection),
      links: obj.tags.links,
      meta: obj.tags.meta
    }
  end
end
