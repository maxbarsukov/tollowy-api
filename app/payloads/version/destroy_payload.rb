class Version::DestroyPayload < Version::Payload
  def self.create(_obj)
    {
      data: {
        type: 'version',
        meta: {
          message: 'Version successfully destroyed'
        }
      }
    }
  end
end
