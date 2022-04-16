class Schemas::RoleValue < Schemas::Base
  def self.data
    {
      title: 'Role Value',
      enum: [-30, -20, -10, 0, 10, 20, 30, 40, 50],
      type: :integer,
      description: 'An enumeration'
    }
  end
end
