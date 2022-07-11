class User::Show
  include Interactor::Organizer

  organize User::SetAmIFollow
end
