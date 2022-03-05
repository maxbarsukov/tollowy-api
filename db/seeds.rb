### ROLES
unless Role.exists?
  Role::ROLES.each do |role_name|
    Role.create!(name: role_name)
  end
end

### USERS
unless User.exists?
  2.times do |ind|
    sym = ind.to_s
    User.create!(
      email: "#{sym}@mail.com",
      username: sym * 3,
      password: sym * 6
    )
  end
end
