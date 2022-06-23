class User::FetchPosts
  include Interactor

  delegate :query_params, :pagination_params, :user, :current_user, :controller, to: :context

  # rubocop:disable Metrics/AbcSize
  def call
    context.options = { signed_in: controller.send(:user_signed_in?) }

    filtered_posts = PostsFilter.new.call(user.posts, controller.params)
    post_query = PostQuery.new(filtered_posts, query_params)

    paginated = controller.send(:paginate, post_query.results, pagination_params)
    paginated.collection = LikedPostsQuery.new(paginated.collection, current_user).call if context.options[:signed_in]

    context.posts = paginated
  end
  # rubocop:enable Metrics/AbcSize
end
