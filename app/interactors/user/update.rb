class User::Update
  include Interactor::Organizer

  organize User::UpdateAttributes,
           User::SetAmIFollow
end
