class MainRoleSerializer
  def self.call(role)
    {
      name: role.name,
      value: role.value
    }
  end
end
