class User::Comments
  include Interactor::Organizer

  before do
    context.comments = context.user.comments
  end

  organize Comment::Paginate
end
