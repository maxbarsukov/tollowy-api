class Api::V1::PostsController < Api::V1::ApiController
  include Concerns::HasCommentsTree

  before_action :set_post, only: %i[show update destroy comments]

  # GET /api/v1/posts
  def index
    result = Post::Index.call(
      controller: self,
      query_params: query_params,
      pagination_params: pagination_params,
      current_user: current_user
    )

    payload result, Post::IndexPayload
  end

  # GET /api/v1/posts/:id/comments
  def comments
    comments_for(@post.comments)
  end

  # GET /api/v1/posts/:id
  def show
    result = Post::Show.call(
      current_user: current_user,
      post: @post
    )
    payload result, Post::ShowPayload
  end

  # POST /api/v1/posts
  def create
    authenticate_good_standing_user!

    result = Post::Create.call(
      post_params: post_params,
      current_user: current_user
    )
    payload result, Post::CreatePayload, status: :created
  end

  # PATCH /api/v1/posts/:id
  # PUT /api/v1/posts/:id
  def update
    authorize @post

    result = Post::Update.call(
      post_params: post_params,
      post: @post
    )
    payload result, Post::UpdatePayload
  end

  # DELETE /api/v1/posts/:id
  def destroy
    authorize @post

    @post.destroy!
    json_response Post::DestroyPayload.create(nil)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    json_params(%i[body])
  end
end
