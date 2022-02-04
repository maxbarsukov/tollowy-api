module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::ErrorHandler

      respond_to :json
    end
  end
end
