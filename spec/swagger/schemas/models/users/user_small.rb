class Schemas::UserSmall < Schemas::Base
  def self.data
    {
      title: 'User Small',
      description: 'User object with less data',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::UserAttributes.ref
      },
      required: %w[id type attributes]
    }
  end
end
