class Schemas::UserAttributes < Schemas::Base
  def self.data
    {
      title: 'User Attributes',
      description: 'Attributes for User',
      type: :object,
      properties: {
        email: { type: :string },
        username: { type: :string },
        created_at: { type: :string },
        role: Schemas::Role.ref
      },
      required: %w[email username created_at role]
    }
  end
end
