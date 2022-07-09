class Schemas::PostAttributes < Schemas::Base
  def self.data
    {
      title: 'Post Attributes',
      description: 'Attributes for Post',
      type: :object,
      properties: {
        body: { type: :string },
        created_at: { type: :string },
        updated_at: { type: :string },
        comments_count: { type: :integer },
        likes_count: { type: :integer },
        dislikes_count: { type: :integer },
        score: { type: :integer },
        tag_list: {
          type: :array,
          items: {
            type: :string
          }
        }
      },
      required: %w[body created_at updated_at comments_count likes_count dislikes_count score tag_list]
    }
  end
end
