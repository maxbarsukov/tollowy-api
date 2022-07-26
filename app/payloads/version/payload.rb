class Version::Payload < ApplicationPayload
  def self.create(obj)
    VersionSerializer.call(obj.version)
  end
end
