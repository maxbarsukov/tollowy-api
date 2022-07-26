class Version::Index
  include Interactor::Organizer

  before do
    context.versions = Version.for_user(context.current_user)
  end

  organize Version::Paginate
end
