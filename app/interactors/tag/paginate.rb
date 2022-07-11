class Tag::Paginate
  include Interactor

  delegate :current_user, :controller, :tags, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, tag_query.results, pagination_params)
    paginated.collection = load_following_data(paginated)

    context.tags = paginated
  end

  private

  def load_following_data(paginated)
    return paginated.collection unless controller.send(:user_signed_in?)

    FollowingByCurrentUserQuery.new(
      paginated.collection, Tag, current_user, Tag::NAME
    ).call
  end

  def tag_query
    filtered_tags = TagsFilter.new.call(tags, controller.params)
    TagQuery.new(filtered_tags, query_params)
  end

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end
end
