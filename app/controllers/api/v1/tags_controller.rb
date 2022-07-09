class Api::V1::TagsController < Api::V1::ApiController
  before_action :set_tag, except: %i[index]

  # GET /api/v1/tags
  def index
    result = Tag::Index.call(controller: self, tags: Tag.all, current_user: current_user)
    payload result, Tag::IndexPayload
  end

  # GET /api/v1/tags/:id/posts
  # GET /api/v1/tags/:id/followers
  # GET /api/v1/tags/:id
  %w[posts followers show].each do |action|
    define_method(action) do
      result = "Tag::#{action.capitalize}".constantize.call(
        controller: self,
        tag: @tag,
        current_user: current_user
      )

      payload result, "Tag::#{action.capitalize}Payload".constantize
    end
  end

  private

  def set_tag
    @tag = Tag.find_by!(name: params[:id])
  end
end
