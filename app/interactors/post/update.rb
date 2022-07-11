class Post::Update
  include Interactor::Organizer

  organize Post::UpdateAttributes,
           Post::SetMyRate
end
