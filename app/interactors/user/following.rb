class User::Following
  include Interactor

  delegate :controller, :user, to: :context
  attr_accessor :query_params, :pagination_params

  def call
    set_params!
    follows = user.follows_scoped.order(created_at: :desc)
    paginated = controller.send(:paginate, follows, pagination_params)

    context.follows = paginated
  end

  private

  def set_params!
    @query_params = controller.send(:query_params)
    @pagination_params = controller.send(:pagination_params)
  end
end
