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
        meta: Schemas::CommentMeta.ref,
        children: Schemas::CommentChildren.ref
      },
      required: %w[id type attributes meta]
    }
  end
end
