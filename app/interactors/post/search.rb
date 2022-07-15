class Post::Search
  include Interactor

  delegate :controller, :current_user, to: :context
  attr_accessor :pagination_params

  def call
    set_params!

    post_search = Post.pagy_search(
      controller.params[:q],
      fields: %w[body^3 tag_list],
      match: :text_middle,
      boost_by: { cached_votes_total: { factor: 1.5 } },
      boost_by_recency: { created_at: { factor: 1.6, scale: '7d', decay: 0.4 } },
      misspellings: { below: 5, edit_distance: 2 },
      includes:
    )

    paginated = controller.send(:paginate, post_search, pagination_params.merge(searchkick: true))
    paginated.collection = load_votes_data(paginated.collection).map(&:itself)

    context.posts = paginated
  end

  private

  def load_votes_data(collection)
    return collection unless controller.send(:user_signed_in?)

    current_user_votes = current_user.votes.where(votable_type: 'Post')
    current_user_votes_ids = current_user_votes.ids

    collection.each do |post|
      post_votes = post.votes_for

      post.my_rate = my_rate(current_user_votes, current_user_votes_ids, post_votes)
    end
  end

  def my_rate(current_user_votes, current_user_votes_ids, post_votes)
    return 0 unless current_user_votes_ids.intersect?(post_votes.ids)

    vote = (current_user_votes & post_votes).first
    vote.vote_flag ? 1 : -1
  end

  def includes
    controller.send(:user_signed_in?) ? %i[votes_for tags] : %i[tags]
  end

  def set_params!
    @pagination_params = controller.send(:pagination_params)
  end
end
