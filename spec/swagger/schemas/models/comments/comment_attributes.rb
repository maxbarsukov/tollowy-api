class Schemas::CommentAttributes < Schemas::Base
  def self.data
    {
      title: 'Comment Attributes',
      description: 'Attributes for Comment',
      type: :object,
      properties: {
        body: { type: :string },

        user_id: { type: :integer },
        commentable_id: { type: :integer },
        parent_id: { type: :integer, nullable: true },

        created_at: { type: :string },
        edited_at: { type: :string, nullable: true },

        edited: { type: :boolean },
        deleted: { type: :boolean }
      },
      required: %w[body user_id commentable_id parent_id created_at edited deleted]
    }
  end
end
