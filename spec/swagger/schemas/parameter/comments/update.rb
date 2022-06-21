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
      )
    }
  end
end
