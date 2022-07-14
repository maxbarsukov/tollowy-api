class Api::V1::TagsController < Api::V1::ApiController
  before_action :set_tag, except: %i[index search]

  # GET /api/v1/tags
  def index = action_for(:index)

  # GET /api/v1/tags/search
  def search = action_for(:search)

  # GET /api/v1/tags/:id/posts
  # GET /api/v1/tags/:id/followers
  # GET /api/v1/tags/:id
  %i[posts followers show].each do |action|
    define_method(action) { action_for(action, tag: @tag) }
  end

  private

  def set_tag
    @tag = Tag.find_by!(name: params[:id])
  end
end
