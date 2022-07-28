class Schemas::InvalidValue < Schemas::Base
  def self.data
    {
      title: 'Invalid Value Error',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['400'] },
              code: { type: :string, enum: ['bad_request'] },
              title: { type: :string, enum: ['Invalid value, no such token'] }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
