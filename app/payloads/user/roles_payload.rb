class User::RolesPayload < ApplicationPayload
  def self.create(obj)
    {
      **RoleSerializer.call(obj.roles.collection),
      links: obj.roles.links,
      meta: obj.roles.meta
    }
  end
end
