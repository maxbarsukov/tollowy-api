class Comment::Paginate
  include Interactor

  delegate :current_user, :controller, :comments, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, comment_query.results, pagination_params)
    paginated.collection = load_votable_data(paginated.collection)

    context.comments = paginated
  end

  private

  def load_votable_data(collection)
    return collection unless controller.send(:user_signed_in?)

    LikedVotableQuery.new(
      collection, Comment, current_user
    ).call
  end

  def comment_query
    CommentQuery.new(comments, query_params)
  end

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end
end
