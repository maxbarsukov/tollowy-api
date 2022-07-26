class Schemas::VersionAttributes < Schemas::Base
  def self.data
    {
      title: 'Version Attributes',
      description: 'Attributes for Version',
      type: :object,
      properties: {
        v: {
          title: 'Version',
          type: :string,
          pattern: '^(?:(\d+)\.)?(?:(\d+)\.)?(\d+)$'
        },
        link: {
          title: 'Link',
          type: :string,
          minLength: 1,
          maxLength: 2083
        },
        size: {
          title: 'Size in bytes',
          minimum: 1,
          maximum: 2_147_483_647,
          type: :integer
        },
        for_role: {
          type: :string,
          enum: Version::AVAILABLE_FOR_ROLE
        },
        whats_new: {
          title: 'Whats New',
          type: :string,
          minLength: 1,
          maxLength: 10_000
        }
      },
      required: %w[v link size for_role whats_new]
    }
  end
end
