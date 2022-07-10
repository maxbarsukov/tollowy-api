class Api::V1::PostsController < Api::V1::ApiController
  before_action :set_post, only: %i[show update destroy comments tags]

  # GET /api/v1/posts
  def index = action_for(:index, {})

  # GET /api/v1/posts/feed
  def feed
    authenticate_good_standing_user!

    action_for :feed, {}
  end

  # GET /api/v1/posts/:id/comments
  def comments = action_for(:comments)

  # GET /api/v1/posts/:id/tags
  def tags = action_for(:tags)

  # GET /api/v1/posts/:id
  def show = action_for(:show)

  # POST /api/v1/posts
  def create
    authenticate_good_standing_user!

    action_for :create, { post_params: post_params }, :created
  end

  # PATCH /api/v1/posts/:id
  # PUT /api/v1/posts/:id
  def update
    authorize @post

    action_for :update, { post_params: post_params, post: @post }
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
