class Tag::IndexPayload < Tag::Payload
  def self.create(obj)
    {
      **TagSerializer.call(obj.tags.collection, { params: obj.options }),
      links: obj.tags.links,
      meta: obj.tags.meta
    }
  end
end
