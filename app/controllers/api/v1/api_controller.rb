module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::ErrorHandler
      include Concerns::Response

      respond_to :json
    end
  end
end
