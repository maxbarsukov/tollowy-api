class Api::V1::CommentsController < Api::V1::ApiController
  before_action :set_comment, only: %i[show update destroy]

  # GET /api/v1/comments/:id
  def show = action_for(:show, comment: @comment)

  # POST /api/v1/comments
  def create
    authenticate_good_standing_user!
    action_for :create, { comment_params: create_params }, :created
  end

  # PATCH/PUT /api/v1/comments/:id
  def update
    authorize @comment
    action_for :update, { comment_params: update_params, comment: @comment }
  end

  # DELETE /api/v1/comments/:id
  def destroy
    authorize @comment
    action_for :destroy, comment: @comment
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def create_params
    json_params(%i[body commentable_type commentable_id]).tap do |p|
      p[:commentable_type] ||= 'Post'
    end
  end

  def update_params = json_params(%i[body])
end
