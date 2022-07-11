class User::Paginate
  include Interactor

  delegate :current_user, :controller, :users, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!

    paginated = controller.send(:paginate, users_query.results, pagination_params)
    paginated.collection = load_following_data(paginated).includes(%i[roles roles_users])

    context.users = paginated
  end

  private

  def load_following_data(paginated)
    return paginated.collection unless controller.send(:user_signed_in?)

    User.following_for_current_user(paginated.collection, current_user.id)
  end

  def users_query
    filtered_users = UsersFilter.new.call(users, controller.params)
    UserQuery.new(filtered_users, query_params)
  end

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end
end
