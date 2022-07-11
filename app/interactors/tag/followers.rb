class Tag::Followers
  include Interactor::Organizer

  before do
    context.users = User.where(id: context.tag.followings.pluck(:follower_id))
  end

  organize User::Paginate
end
