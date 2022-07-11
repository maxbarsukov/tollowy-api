class Schemas::TagSmall < Schemas::Base
  def self.data
    {
      title: 'Tag Small',
      description: 'Tag object with less data',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::TagAttributes.ref
      },
      required: %w[id type attributes]
    }
  end
end
