class Schemas::UserMeta < Schemas::Base
  def self.data
    {
      title: 'User Attributes',
      description: 'Attributes for User',
      type: :object,
      properties: {
        am_i_follow: { type: :boolean, nullable: true }
      },
      required: %w[am_i_follow]
    }
  end
end
