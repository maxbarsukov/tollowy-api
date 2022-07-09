class User::Index
  include Interactor

  delegate :current_user, :controller, :users, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, users_query.results, pagination_params)
    paginated.collection = load_following_data(paginated).includes(%i[roles roles_users])

    context.users = paginated
    set_options!
  end

  private

  def load_following_data(paginated)
    return paginated.collection unless signed_in?

    paginated
      .collection
      .joins(
        User.sanitize_sql_array(
          [
            'LEFT JOIN follows ON follows.followable_id = users.id ' \
            "AND follows.follower_id = ? AND follows.blocked = FALSE AND follows.followable_type = 'User'",
            current_user.id
          ]
        )
      )
      .select('users.* AS users_data, follows.id IS NOT NULL AS am_i_follow')
      .group('am_i_follow, users.id')
  end

  def users_query
    filtered_users = UsersFilter.new.call(users, controller.params)
    UserQuery.new(filtered_users, query_params)
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
