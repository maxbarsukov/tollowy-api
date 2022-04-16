module Api::V1
  class PostsController < ApiController
    before_action :set_post, only: %i[show update destroy]

    # GET /api/v1/posts
    def index
      @posts = Post.all
      json_response PostSerializer.call(@posts)
    end

    # GET /api/v1/posts/:id
    def show
      json_response PostSerializer.call(@post)
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
end
