class Post::Show
  include Interactor::Organizer

  organize Post::SetMyRate
end
