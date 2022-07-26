class Schemas::Version < Schemas::Base
  def self.data
    {
      title: 'Version',
      description: 'Version object',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::VersionAttributes.ref
      },
      required: %w[id type attributes]
    }
  end
end
