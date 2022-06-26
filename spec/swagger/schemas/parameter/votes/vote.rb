class Schemas::Parameter::Votes::Vote < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'vote',
        attr: {
          properties: {
            votable_id: {
              description: 'Votable ID',
              type: :integer
            },
            votable_type: {
              description: 'Votable type ("Post" is default)',
              type: :string,
              required: false
            }
          },
          required: ['votable_id']
        }
      )
    }
  end
end
