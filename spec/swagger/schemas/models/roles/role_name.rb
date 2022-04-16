class Schemas::RoleName < Schemas::Base
  def self.data
    {
      title: 'Role Name',
      enum: %w[unconfirmed banned warned user premium primary owner moderator admin],
      type: :string,
      description: 'An enumeration'
    }
  end
end
