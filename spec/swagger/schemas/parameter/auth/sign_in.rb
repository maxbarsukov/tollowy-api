class Schemas::Parameter::Auth::SignIn < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            type: { type: :string, enum: ['auth'] },
            attributes: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              },
              required: %w[email password]
            }
          },
          required: %w[type attributes]
        }
      }
    }
  end
end
