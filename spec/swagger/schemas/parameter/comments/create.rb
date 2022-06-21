class Schemas::Parameter::Comments::Create < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'comment',
        attr: {
          properties: {
            body: {
              description: 'Comment body',
              type: :string
            },
            commentable_type: {
              description: 'Commentable type',
              enum: ['Post'],
              type: :string
            },
            commentable_id: {
              description: 'Commentable ID',
              type: :string
            },
            parent_id: {
              description: 'Comment parent ID',
              type: :string,
              required: false
            }
          }
        }
      )
    }
  end
end
