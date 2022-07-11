class Tag::Posts
  include Interactor::Organizer

  before do
    context.posts = context.tag.posts
  end

  organize Post::Paginate
end
