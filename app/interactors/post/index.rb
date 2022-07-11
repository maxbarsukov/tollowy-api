class Post::Index
  include Interactor::Organizer

  before do
    context.posts = Post.all
  end

  organize Post::Paginate
end
