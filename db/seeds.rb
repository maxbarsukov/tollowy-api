### CLEAR ALL
User.destroy_all
Role.destroy_all

### ROLES
Role::ROLES.each do |role_name|
  Role.create!(name: role_name)
end

2.times do |ind|
  sym = ind.to_s
  User.create!(
    email: "#{sym}@mail.com",
    username: sym * 3,
    password: sym * 6
  )
end
