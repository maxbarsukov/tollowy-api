class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[show update posts comments]

  # GET /api/v1/users
  def index = action_for(:index)

  # GET /api/v1/users/:id/posts
  def posts = action_for(:posts, user: @user)

  # GET /api/v1/users/:id/comments
  def comments = action_for(:comments, user: @user)

  # GET /api/v1/users/:id
  def show = action_for(:show, user: @user)

  # PATCH /api/v1/users/:id
  # PUT /api/v1/users/:id
  def update
    authorize_with_multiple(@user, user_params[:role], :update?, RolePolicy) if user_params.key?(:role)
    authorize @user

    action_for :update, { user: @user, user_params: user_params }
  end

  private

  def set_user
    @user = User.find(params.require(:id))
  end

  def user_params
    return params.permit(:avatar) if params[:avatar] && !params[:data]

    json_params(%i[username email password current_password role]).merge(params.permit(:avatar))
  end
end
