module Api::V1
  class HomeController < Api::V1::ApiController
    before_action :authenticate_user!

    def index
      json_response({ message: "If you see this, you're in!" })
    end
  end
end
