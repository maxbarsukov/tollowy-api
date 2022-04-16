class Schemas::UnauthorizedError < Schemas::Base
  def self.data
    {
      title: 'Unauthorized Error',
      description: 'User must sign in before continuing',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['401'] },
              code: { type: :string, enum: ['unauthorized'] },
              title: { type: :string, enum: ['You need to sign in or sign up before continuing'] }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
