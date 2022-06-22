class Schemas::UserAttributes < Schemas::Base
  def self.data
    {
      title: 'User Attributes',
      description: 'Attributes for User',
      type: :object,
      properties: {
        email: { type: :string },
        username: { type: :string },
        avatar: Schemas::UserAvatar.ref,
        created_at: { type: :string },
        posts_count: { type: :integer },
        comments_count: { type: :integer },
        role: Schemas::Role.ref
      },
      required: %w[email username created_at role posts_count comments_count]
    }
  end
end
