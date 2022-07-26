class Schemas::Parameter::Auth::RequestPasswordReset < Schemas::Base
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
                email: { type: :string }
              },
              required: %w[email]
            }
          },
          required: %w[type attributes]
        }
      },
      example: {
        data: {
          type: 'auth',
          attributes: { email: 'MyMilo@milo.sru' }
        }
      }
    }
  end
end
