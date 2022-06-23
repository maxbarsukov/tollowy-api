class PostFixture < ApplicationFixture
  seed do
    posts = []

    User.take(30).each do |user|
      p = user.posts.new(body: "Hello from #{user.id} user!")
      puts "#{user.id}:\tPost(#{p.body}, #{p.user_id})"
      posts << p
    end

    import posts
  end
end
