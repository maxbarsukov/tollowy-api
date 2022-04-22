class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[show update]

  # GET /api/v1/users
  def index
    scope = User.includes(%i[roles roles_users])
    filtered_users = UsersFilter.new.call(scope, params)
    user_query = UserQuery.new(filtered_users, query_params)

    @paginated = paginate(
      user_query.results,
      pagination_params
    )
    json_response User::IndexPayload.create(@paginated)
  end

  # GET /api/v1/users/:id
  def show
    json_response UserSerializer.call(@user)
  end

  # PATCH /api/v1/users/:id
  # PUT /api/v1/users/:id
  def update
    authorize_with_multiple(@user, user_params[:role], :update?, RolePolicy) if user_params.key?(:role)
    authorize @user

    result = User::Update.call(user: @user, user_params: user_params)

    if result.success?
      json_response UserSerializer.call(result.user)
    else
      json_error result.error_data
    end
  end

  private

  def set_user
    @user = User.find(params.require(:id))
  end

  def user_params
    json_params(%i[username email password current_password role])
  end
end
