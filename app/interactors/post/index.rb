class Post::Index
  include Interactor

  delegate :current_user, :controller, :posts, to: :context

  # rubocop:disable Metrics/AbcSize
  def call
    query_params = controller.send(:query_params)
    pagination_params = controller.send(:pagination_params)

    filtered_posts = PostsFilter.new.call(posts, controller.params)
    post_query = PostQuery.new(filtered_posts, query_params)

    paginated = controller.send(:paginate, post_query.results, pagination_params)

    if signed_in?
      paginated.collection = LikedVotableQuery.new(
        paginated.collection, Post, current_user
      ).call
    end

    context.posts = paginated
    set_options!
  end
  # rubocop:enable Metrics/AbcSize

  def signed_in?
    return @signed_in if defined? @signed_in

    @signed_in = controller.send(:user_signed_in?)
  end

  def set_options!
    context.options = { signed_in: signed_in? }
  end
end
