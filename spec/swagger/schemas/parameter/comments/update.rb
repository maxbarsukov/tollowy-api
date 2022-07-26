class Schemas::Parameter::Comments::Update < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'comment',
        attr: {
          properties: {
            body: {
              description: 'Comment body',
              type: :string
            }
          }
        }
      ),
      example: {
        data: {
          type: 'comment',
          attributes: {
            body: 'My super comment | updated!'
          }
        }
      }
    }
  end
end
