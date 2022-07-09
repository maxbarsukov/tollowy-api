class Schemas::User < Schemas::Base
  def self.data
    {
      title: 'User',
      description: 'User object',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::UserAttributes.ref,
        meta: Schemas::UserMeta.ref
      },
      required: %w[id type]
    }
  end
end
