class Post::Paginate
  include Interactor

  delegate :current_user, :controller, :posts, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, post_query.results, pagination_params)
    paginated.collection = load_votable_data(paginated.collection).includes([:tags])

    context.posts = paginated
  end

  private

  def load_votable_data(collection)
    return collection unless controller.send(:user_signed_in?)

    LikedVotableQuery.new(
      collection, Post, current_user
    ).call
  end

  def post_query
    filtered_posts = PostsFilter.new.call(posts, controller.params)
    PostQuery.new(filtered_posts, query_params)
  end

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end
end
