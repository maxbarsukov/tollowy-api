class User::FollowingTags
  include Interactor::Organizer

  before do
    context.tags = context.user.following_tags
  end

  organize Tag::Paginate
end
