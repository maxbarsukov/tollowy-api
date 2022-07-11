class Post::Tags
  include Interactor::Organizer

  before do
    context.tags = context.post.tags
  end

  organize Tag::Paginate
end
