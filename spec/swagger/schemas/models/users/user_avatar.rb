class Schemas::UserAvatar < Schemas::Base
  def self.data
    {
      title: 'User Avatar',
      type: :object,
      properties: {
        url: { type: :string, nullable: true }
      },
      required: %w[url]
    }
  end
end
