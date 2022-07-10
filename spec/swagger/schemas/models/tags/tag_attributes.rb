class Schemas::TagAttributes < Schemas::Base
  def self.data
    {
      title: 'Tag Attributes',
      description: 'Attributes for Tag',
      type: :object,
      properties: {
        name: { type: :string },
        created_at: { type: :string },
        updated_at: { type: :string },
        followers_count: { type: :integer },
        taggings_count: { type: :integer }
      },
      required: %w[name created_at updated_at followers_count taggings_count]
    }
  end
end
