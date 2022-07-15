class Post::SearchComments
  include Interactor

  delegate :controller, :post, :current_user, to: :context
  attr_accessor :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, search, pagination_params.merge(searchkick: true))
    paginated.collection = load_votes_data(paginated.collection).map(&:itself)

    context.comments = paginated
  end

  private

  def search
    Comment.pagy_search(
      controller.params[:q],
      where: { commentable_type: 'Post', commentable_id: post.id },
      fields: [:body],
      match: :text_middle,
      boost_by: {
        cached_votes_up: { factor: 1.2 },
        cached_votes_down: { factor: 0.8 }
      },
      boost_by_recency: { created_at: { factor: 1.6, scale: '14d', decay: 0.5 } },
      misspellings: { below: 5, edit_distance: 2 },
      includes:
    )
  end

  def load_votes_data(collection)
    return collection unless controller.send(:user_signed_in?)

    current_user_votes = current_user.votes.where(votable_type: 'Comment')
    current_user_votes_ids = current_user_votes.ids

    collection.each do |comment|
      comment_votes = comment.votes_for

      comment.my_rate = my_rate(current_user_votes, current_user_votes_ids, comment_votes)
    end
  end

  def my_rate(current_user_votes, current_user_votes_ids, comment_votes)
    return 0 unless current_user_votes_ids.intersect?(comment_votes.ids)

    vote = (current_user_votes & comment_votes).first
    vote.vote_flag ? 1 : -1
  end

  def includes
    controller.send(:user_signed_in?) ? %i[votes_for] : []
  end

  def set_params!
    @pagination_params = controller.send(:pagination_params)
  end
end
