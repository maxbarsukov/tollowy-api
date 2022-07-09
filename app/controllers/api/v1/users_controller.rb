class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[show update posts comments]

  # GET /api/v1/users
  def index
    result = User::Index.call(interactor_context(users: User.all))
    payload result, User::IndexPayload
  end

  # GET /api/v1/users/:id/posts
  def posts
    result = User::Posts.call(interactor_context(user: @user))
    payload result, User::PostsPayload
  end

  # GET /api/v1/users/:id/comments
  def comments
    result = User::Comments.call(interactor_context(user: @user))
    payload result, User::CommentsPayload
  end

  # GET /api/v1/users/:id
  def show
    result = User::Show.call(interactor_context(user: @user))
    payload result, User::ShowPayload
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

  def interactor_context(hash = {})
    {
      controller: self,
      current_user: current_user
    }.merge(hash)
  end

  def user_params
    return params.permit(:avatar) if params[:avatar] && !params[:data]

    json_params(%i[username email password current_password role]).merge(params.permit(:avatar))
  end
end
