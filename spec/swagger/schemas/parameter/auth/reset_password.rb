class Schemas::Parameter::Auth::ResetPassword < Schemas::Base
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
                password: { type: :string },
                reset_token: { type: :string }
              },
              required: %w[password reset_token]
            }
          },
          required: %w[type attributes]
        }
      },
      example: {
        data: {
          type: 'auth',
          attributes: {
            password: 'newPassword11',
            reset_token: 'super-reset-token'
          }
        }
      }
    }
  end
end
