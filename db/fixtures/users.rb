class UserFixture < ApplicationFixture
  seed do
    silence_warnings do
      BCrypt::Engine::DEFAULT_COST = 7
    end

    users = []

    100.times do |ind|
      sym = ind.to_s
      u = User.new(
        email: "#{sym}@mail.com",
        username: "user#{sym * 3}",
        password: sym * 6
      )
      puts "#{ind}:\tUser(#{u.email}, #{u.username}, #{u.password})"
      users << u
    end

    import users
    users.map { |u| u.add_role(:user) }
  end
end
