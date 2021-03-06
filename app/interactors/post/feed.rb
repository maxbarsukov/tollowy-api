class Post::Feed
  include Interactor::Organizer

  delegate :current_user, :controller, to: :context

  organize Post::GetFollowingPosts,
           Post::Paginate
end
