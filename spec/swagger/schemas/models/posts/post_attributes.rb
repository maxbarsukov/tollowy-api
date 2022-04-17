class Schemas::PostAttributes < Schemas::Base
  def self.data
    {
      title: 'Post Attributes',
      description: 'Attributes for Post',
      type: :object,
      properties: {
        body: { type: :string },
        created_at: { type: :string },
        updated_at: { type: :string }
      },
      required: %w[body created_at updated_at]
    }
  end
end
