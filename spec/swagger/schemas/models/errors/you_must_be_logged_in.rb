class Schemas::YouMustBeLoggedIn < Schemas::Base
  def self.data
    {
      title: 'Unauthorized Error',
      description: 'User must log in  before continuing',
      type: :object,
      properties: {
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              status: { type: :string, enum: ['401'] },
              code: { type: :string, enum: ['unauthorized'] },
              title: { type: :string },
              detail: { type: :array, item: { type: :string, enum: ['You must be logged in'] } }
            },
            required: %w[status code title]
          }
        }
      },
      required: ['errors']
    }
  end
end
