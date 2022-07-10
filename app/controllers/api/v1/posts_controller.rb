class Api::V1::PostsController < Api::V1::ApiController
  before_action :set_post, only: %i[show update destroy comments tags]

  # GET /api/v1/posts
  def index
    result = Post::Index.call(interactor_context)
    payload result, Post::IndexPayload
  end

  # GET /api/v1/posts/feed
  def feed
    authenticate_good_standing_user!

    result = Post::FetchFeed.call(interactor_context)
    payload result, Post::FeedPayload
  end

  # GET /api/v1/posts/:id/comments
  def comments
    result = Post::Comments.call(interactor_context(post: @post))
    payload result, Post::CommentsPayload
  end

  # GET /api/v1/posts/:id/tags
  def tags
    result = Post::Tags.call(interactor_context(post: @post))
    payload result, Post::TagsPayload
  end

  # GET /api/v1/posts/:id
  def show
    result = Post::Show.call(interactor_context(post: @post))
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
