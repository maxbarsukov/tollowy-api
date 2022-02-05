### ROLES
Role::ROLES.each do |role_name|
  Role.create!(name: role_name)
end
