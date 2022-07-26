class Version::IndexPayload < Version::Payload
  def self.create(obj)
    {
      **VersionSerializer.call(obj.versions.collection),
      links: obj.versions.links,
      meta: obj.versions.meta
    }
  end
end
