class Post::Comments
  include Interactor::Organizer

  before do
    context.comments = context.post.comments
  end

  organize Comment::Paginate
end
