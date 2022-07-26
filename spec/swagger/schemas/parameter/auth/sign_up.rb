class Schemas::Parameter::Auth::SignUp < Schemas::Base
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
                username: { type: :string },
                password: { type: :string }
              },
              required: %w[email username password]
            }
          },
          required: %w[type attributes]
        }
      },
      example: {
        data: {
          type: 'auth',
          attributes: {
            email: 'MyMilo@milo.sru',
            username: 'UniqueUsername',
            password: 'SecretPassword123'
          }
        }
      }
    }
  end
end
