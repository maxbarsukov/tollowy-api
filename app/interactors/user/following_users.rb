class User::FollowingUsers
  include Interactor::Organizer

  before do
    context.users = context.user.following_users
  end

  organize User::Paginate
end
