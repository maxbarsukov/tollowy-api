class Schemas::InvalidCredentialsError < Schemas::Base
  def self.data
    {
      title: 'Invalid Credentials Error',
      description: "User's token is invalid",
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['401'] },
              code: { type: :string, enum: ['unauthorized'] },
              title: { type: :string, enum: ['Invalid credentials'] }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
