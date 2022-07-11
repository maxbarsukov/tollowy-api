class Comment::Show
  include Interactor::Organizer

  organize Comment::SetAmIFollow
end
