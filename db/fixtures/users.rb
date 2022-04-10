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
        password: "Aa#{sym * 4}",
        role: :user
      )
      puts "#{ind}:\tUser(#{u.email}, #{u.username}, #{u.password})"
      users << u
    end

    import users
  end
end
