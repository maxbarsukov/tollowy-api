class Api::V1::VersionsController < Api::V1::ApiController
  before_action :authenticate_good_standing_user!, except: %i[index show]
  before_action :set_version, only: %i[show update destroy]

  # GET /api/v1/versions
  def index
    action_for :index
  end

  # POST /api/v1/versions
  def create
    authorize_with_error(Version.new)
    action_for :create, { version_params: }, :created
  end

  # GET /api/v1/version/:v
  def show
    authorize_with_error @version
    action_for :show, version: @version
  end

  # PATCH /api/v1/versions/:v
  # PUT /api/v1/versions/:v
  def update
    authorize_with_error @version
    action_for :update, { version_params:, version: @version }
  end

  # DELETE /api/v1/versions/:v
  def destroy
    authorize_with_error @version
    action_for :destroy, version: @version
  end

  private

  def set_version
    @version = Version.find_by!(v: params.require(:id))
  end

  def version_params
    json_params(%i[v link size for_role whats_new])
  end
end
