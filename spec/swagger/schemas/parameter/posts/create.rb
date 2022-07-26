class Schemas::Parameter::Posts::Create < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'post',
        attr: {
          properties: {
            body: {
              description: 'Post body',
              type: :string
            }
          }
        }
      ),
      example: {
        data: {
          type: 'post',
          attributes: {
            body: 'NEW POST!!!!'
          }
        }
      }
    }
  end
end
