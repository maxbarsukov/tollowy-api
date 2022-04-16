class Schemas::Role < Schemas::Base
  def self.data
    {
      title: 'Role',
      description: 'Role',
      type: :object,
      properties: {
        name: { type: :string },
        value: Schemas::RoleValue.ref
      },
      required: %w[name value]
    }
  end
end
