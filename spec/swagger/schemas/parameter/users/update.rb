class Schemas::Parameter::Users::Update < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'user',
        attr: {
          properties: {
            current_password: {
              description: 'Current password',
              type: :string
            },
            password: {
              description: 'New password',
              type: :string
            },
            email: { type: :string },
            username: { type: :string },
            role: {
              oneOf: [
                Schemas::RoleValue.ref,
                Schemas::RoleName.ref
              ]
            }
          }
        }
      ),
      example: {
        data: {
          type: 'user',
          attributes: {
            current_password: '123',
            password: '1234',
            email: 'MyMilo@milo.sru',
            role: 'admin'
          }
        }
      }
    }
  end
end
