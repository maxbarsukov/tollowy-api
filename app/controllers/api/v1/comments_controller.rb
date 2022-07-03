class Api::V1::CommentsController < Api::V1::ApiController
  before_action :set_comment, only: %i[show update destroy]

  # GET /api/v1/comments/:id
  def show
    json_response CommentSerializer.call(@comment)
  end

  # POST /api/v1/comments
  def create
    authenticate_good_standing_user!

    result = Comment::Create.call(
      comment_params: create_params,
      current_user: current_user
    )
    payload result, Comment::CreatePayload, status: :created
  end

  # PATCH/PUT /api/v1/comments/:id
  def update
    authorize @comment

    result = Comment::Update.call(
      comment_params: update_params,
      comment: @comment
    )
    payload result, Comment::UpdatePayload
  end

  # DELETE /api/v1/comments/:id
  def destroy
    authorize @comment

    result = Comment::Destroy.call(
      comment: @comment
    )
    payload result, Comment::DestroyPayload
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
