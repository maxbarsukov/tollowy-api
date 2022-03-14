class UserFixture < ApplicationFixture
  seed do
    users = []

    10.times do |ind|
      sym = ind.to_s
      u = User.new(
        email: "#{sym}@mail.com",
        username: "user#{sym * 3}",
        password: sym * 6
      )
      u.add_role(:user)
      puts "#{ind}:\tUser(#{u.email}, #{u.username}, #{u.password})"
      users << u
    end

    import users
  end
end
