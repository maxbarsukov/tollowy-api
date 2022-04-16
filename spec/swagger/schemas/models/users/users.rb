class Schemas::Users < Schemas::Base
  def self.data
    {
      title: 'Users',
      description: 'Users',
      type: :array,
      items: Schemas::User.ref
    }
  end
end
