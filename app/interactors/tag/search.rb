class Tag::Search
  include Interactor

  delegate :controller, :current_user, to: :context
  attr_accessor :pagination_params

  def call
    set_params!

    tag_search = Tag.pagy_search(
      controller.params[:q],
      fields: %w[name],
      match: :word_middle,
      boost_by: {
        taggings_count: { factor: 3 },
        followers_count: { factor: 2 }
      },
      boost_by_recency: { updated_at: { scale: '7d', decay: 0.5, factor: 2.5 } },
      misspellings: { below: 5, edit_distance: 2 },
      includes:
    )

    paginated = controller.send(:paginate, tag_search, pagination_params.merge(searchkick: true))
    paginated.collection = load_following_data(paginated.collection).map(&:itself)

    context.tags = paginated
  end

  private

  def load_following_data(collection)
    return collection unless controller.send(:user_signed_in?)

    current_user_follows_ids = current_user.follows.unblocked.for_followable_type(Tag::NAME).ids

    collection.each do |tag|
      tag.am_i_follow = current_user_follows_ids.intersect?(tag.followings.ids)
    end
  end

  def includes
    controller.send(:user_signed_in?) ? [:followings] : []
  end

  def set_params!
    @pagination_params = controller.send(:pagination_params)
  end
end
