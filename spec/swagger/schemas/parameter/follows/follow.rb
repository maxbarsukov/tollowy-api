class Schemas::Parameter::Follows::Follow < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'follow',
        attr: {
          properties: {
            votable_id: {
              description: 'Followable ID',
              type: :integer
            },
            votable_type: {
              description: 'Followable type ("User" is default)',
              type: :string,
              required: false
            }
          },
          required: ['Followable_id']
        }
      )
    }
  end
end
