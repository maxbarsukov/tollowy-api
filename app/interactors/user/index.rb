class User::Index
  include Interactor::Organizer

  before do
    context.users = User.all
  end

  organize User::Paginate
end
