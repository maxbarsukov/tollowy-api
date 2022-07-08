class Post::FetchFeed
  include Interactor::Organizer

  delegate :current_user, :controller, to: :context

  organize Post::GetFollowingPosts,
           Post::Index
end
