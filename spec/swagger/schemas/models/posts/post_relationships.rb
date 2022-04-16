class Schemas::PostRelationships < Schemas::Base
  def self.data
    {
      title: 'Post Relationships',
      description: 'Relationships for Post',
      type: :object,
      properties: {
        user: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string }
              },
              required: %w[id type]
            }
          },
          required: %w[data]
        }
      },
      required: %w[user]
    }
  end
end
