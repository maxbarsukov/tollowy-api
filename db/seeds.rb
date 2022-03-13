### ROLES
unless Role.exists?
  Role::ROLES.each do |role_name|
    Role.create!(name: role_name)
  end
end

### USERS
unless User.exists?
  20.times do |ind|
    sym = ind.to_s
    u = User.create!(
      email: "#{sym}@mail.com",
      username: "user#{sym * 3}",
      password: sym * 6
    )
    u.add_role(:user)
  end
end
