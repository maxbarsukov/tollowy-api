class Schemas::Comment < Schemas::Base
  def self.data
    {
      title: 'Comment',
      description: 'Comment object',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::CommentAttributes.ref,
        meta: {
          type: :object,
          properties: {
            my_rate: { type: :integer, nullable: true }
          }
        }
      },
      required: %w[id type attributes]
    }
  end
end
