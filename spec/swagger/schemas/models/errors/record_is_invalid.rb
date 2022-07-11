class Schemas::RecordIsInvalid < Schemas::Base
  def self.data
    {
      title: 'Record Is Invalid',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['422'] },
              code: { type: :string, enum: ['unprocessable_entity'] },
              title: { type: :string, enum: ['Record Invalid'] },
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
