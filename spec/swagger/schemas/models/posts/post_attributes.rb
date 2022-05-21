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
        comments_count: { type: :integer }
      },
      required: %w[body created_at updated_at comments_count]
    }
  end
end
