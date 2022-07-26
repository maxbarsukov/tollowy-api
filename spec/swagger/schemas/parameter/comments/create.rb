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
              type: :integer
            }
          }
        }
      ),
      example: {
        data: {
          type: 'comment',
          attributes: {
            body: 'My super comment',
            commentable_type: 'Post',
            commentable_id: 123
          }
        }
      }
    }
  end
end
