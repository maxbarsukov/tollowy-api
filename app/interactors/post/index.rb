class Post::Index
  include Interactor

  delegate :current_user, :controller, :posts, to: :context
  attr_accessor :query_params, :pagination_params

  # rubocop:disable Metrics/AbcSize
  def call
    set_params!

    filtered_posts = PostsFilter.new.call(posts, controller.params)
    post_query = PostQuery.new(filtered_posts, query_params)

    paginated = controller.send(:paginate, post_query.results, pagination_params)

    paginated.collection = load_votable_data(paginated.collection)
    paginated.collection = paginated.collection.includes([:tags])

    context.posts = paginated
    set_options!
  end
  # rubocop:enable Metrics/AbcSize

  private

  def load_votable_data(collection)
    return collection unless signed_in?

    LikedVotableQuery.new(
      collection, Post, current_user
    ).call
  end

  def signed_in?
    return @signed_in if defined? @signed_in

    @signed_in = controller.send(:user_signed_in?)
  end

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end

  def set_options!
    context.options = { signed_in: signed_in? }
  end
end
