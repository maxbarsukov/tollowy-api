class Schemas::Error < Schemas::Base
  def self.data
    {
      title: 'Error',
      description: 'JSON:API Error response',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string },
              code: { type: :string },
              title: { type: :string },
              detail: { type: :array, items: { type: :string } }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
