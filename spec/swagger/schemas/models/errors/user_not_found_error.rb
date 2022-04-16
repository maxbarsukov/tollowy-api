class Schemas::UserNotFoundError < Schemas::Base
  def self.data
    {
      title: 'User Not Found',
      description: 'User ID is invalid',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['404'] },
              code: { type: :string, enum: ['not_found'] },
              title: { type: :string, enum: ['Not Found'] }
            },
            required: %w[status code title]
          }
        }
      }
    }
  end
end
