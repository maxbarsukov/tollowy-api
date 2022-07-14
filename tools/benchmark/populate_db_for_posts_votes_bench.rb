# Creates 1000 users and 1000 posts,
# then all posts are randomly rated by 500 random users.
# Use it for benchmarking /api/v1/posts/search?q= as signed in user and so on

# Create users
BCrypt::Engine::DEFAULT_COST = 4
users = []
1000.times do |ind|
  sym = ind.to_s
  u = User.new(
    email: "#{sym}uniq@mail.com",
    username: Faker::Ancient.god + Faker::Number.number(digits: 5).to_s,
    password: "Aa#{sym * 4}"
  )
  users << u
end
User.import users
users.each { |user| user.role = :user }

# Create users
posts = []
creator = User.order('RANDOM()').first
1000.times do |_i|
  posts << creator.posts.new(
    body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4)
  )
end
Post.import posts

# Vote each post
votes = []
booleans = [true, false]
Post.all.each do |post|
  voters = User.limit(500).order('RANDOM()')
  voters.each do |voter|
    votes << Vote.new(
      voter_id: voter.id,
      voter_type: 'User',
      votable_id: post.id,
      votable_type: 'Post',
      vote_flag: booleans.sample
    )
  end
end
Vote.import votes
