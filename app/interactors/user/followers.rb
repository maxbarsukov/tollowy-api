class User::Followers
  include Interactor::Organizer

  before do
    context.users = User.where(id: context.user.followings.pluck(:follower_id))
  end

  organize User::Paginate
end
