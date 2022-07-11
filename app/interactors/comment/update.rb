class Comment::Update
  include Interactor::Organizer

  organize Comment::UpdateAttributes,
           Comment::SetMyRate
end
