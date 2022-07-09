class Comment::Paginate
  include Interactor

  delegate :controller, :comments, :current_user, to: :context

  # rubocop:disable Metrics/AbcSize
  def call
    comments_query = CommentQuery.new(comments, controller.send(:query_params))
    paginated = controller.send(:paginate, comments_query.results, controller.send(:pagination_params))

    if signed_in?
      paginated.collection = LikedVotableQuery.new(
        paginated.collection, Comment, current_user
      ).call
    end

    context.comments = paginated
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
