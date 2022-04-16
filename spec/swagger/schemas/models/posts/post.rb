class Schemas::Post < Schemas::Base
  def self.data
    {
      title: 'Post',
      description: 'Post object',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::PostAttributes.ref,
        relationships: Schemas::PostRelationships.ref
      },
      required: %w[id type]
    }
  end
end
