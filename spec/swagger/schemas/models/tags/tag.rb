class Schemas::Tag < Schemas::Base
  def self.data
    {
      title: 'Tag',
      description: 'Tag object',
      type: :object,
      properties: {
        id: { type: :string },
        type: { type: :string },
        attributes: Schemas::TagAttributes.ref,
        meta: {
          type: :object,
          properties: {
            am_i_follow: { type: :boolean, nullable: true }
          }
        }
      },
      required: %w[id type attributes meta]
    }
  end
end
