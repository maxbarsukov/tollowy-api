class User::Search
  include Interactor

  delegate :controller, :current_user, to: :context
  attr_accessor :pagination_params

  def call
    set_params!

    user_search = User.pagy_search(
      controller.params[:q],
      fields: %w[username^6 email^3 id],
      match: :word_middle,
      misspellings: { below: 5, edit_distance: 2 },
      includes:
    )

    paginated = controller.send(:paginate, user_search, pagination_params.merge(searchkick: true))
    paginated.collection = load_following_data(paginated.collection).map(&:itself)

    context.users = paginated
  end

  private

  def load_following_data(collection)
    return collection unless controller.send(:user_signed_in?)

    current_user_follows_ids = current_user.follows.unblocked.for_followable_type('User').ids

    collection.each do |user|
      user.am_i_follow = current_user_follows_ids.intersect?(user.followings.ids)
    end
  end

  def includes
    controller.send(:user_signed_in?) ? %i[followings roles] : %i[roles]
  end

  def set_params!
    @pagination_params = controller.send(:pagination_params)
  end
end
