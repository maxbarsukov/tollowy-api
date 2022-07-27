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
                username_or_email: { type: :string },
                password: { type: :string }
              },
              required: %w[email password]
            }
          },
          required: %w[type attributes]
        }
      },
      example: {
        data: {
          type: 'auth',
          attributes: {
            username_or_email: 'MyMilo@milo.sru',
            password: 'SecretPassword123'
          }
        }
      }
    }
  end
end
