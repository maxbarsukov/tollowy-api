class Schemas::CommentMeta < Schemas::Base
  def self.data
    {
      title: 'Comment Meta',
      description: 'Comment object meta',
      type: :object,
      properties: {
        children_count: { type: :integer }
      },
      required: %w[children_count]
    }
  end
end
