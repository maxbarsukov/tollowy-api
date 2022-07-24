class User::RemoveRolePayload < ApplicationPayload
  def self.create(_obj)
    {
      data: {
        type: 'role',
        meta: { message: 'Role successfully removed' }
      }
    }
  end
end
