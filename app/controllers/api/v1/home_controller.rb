class Api::V1::HomeController < Api::V1::ApiController
  before_action :authenticate_user!

  # GET /api/v1
  def index
    json_response({ message: "If you see this, you're in!" })
  end
end
