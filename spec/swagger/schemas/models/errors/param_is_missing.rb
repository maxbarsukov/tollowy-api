class Schemas::ParamIsMissing < Schemas::Base
  def self.data
    {
      title: 'Param is missing or the value is empty',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['422'] },
              code: { type: :string, enum: ['unprocessable_entity'] },
              title: { type: :string }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
