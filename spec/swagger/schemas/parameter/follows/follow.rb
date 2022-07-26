class Schemas::Parameter::Follows::Follow < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'follow',
        attr: {
          properties: {
            followable_id: {
              description: 'Followable ID',
              type: :integer
            },
            followable_type: {
              description: 'Followable type ("User" is default)',
              type: :string,
              required: false
            }
          },
          required: ['Followable_id']
        }
      ),
      example: {
        data: {
          type: 'follow',
          attributes: {
            followable_id: 123,
            followable_type: 'Tag'
          }
        }
      }
    }
  end
end
