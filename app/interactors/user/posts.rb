class User::Posts
  include Interactor::Organizer

  before do
    context.posts = context.user.posts
  end

  organize Post::Paginate
end
