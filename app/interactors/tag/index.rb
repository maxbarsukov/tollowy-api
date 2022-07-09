class Tag::Index
  include Interactor

  delegate :current_user, :controller, :tags, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, tag_query.results, pagination_params)
    paginated.collection = load_following_data(paginated)

    context.tags = paginated
    set_options!
  end

  private

  def load_following_data(paginated)
    return paginated.collection unless signed_in?

    FollowingByCurrentUserQuery.new(
      paginated.collection, Tag, current_user, Tag::NAME
    ).call
  end

  def tag_query
    filtered_tags = TagsFilter.new.call(tags, controller.params)
    TagQuery.new(filtered_tags, query_params)
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
