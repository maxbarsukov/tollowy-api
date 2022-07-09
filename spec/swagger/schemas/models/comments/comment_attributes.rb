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
        commentable_type: { type: :string },

        created_at: { type: :string },
        edited_at: { type: :string, nullable: true },

        edited: { type: :boolean },

        likes_count: { type: :integer },
        dislikes_count: { type: :integer },
        score: { type: :integer }
      },
      required: %w[body user_id commentable_id created_at edited likes_count dislikes_count score]
    }
  end
end
