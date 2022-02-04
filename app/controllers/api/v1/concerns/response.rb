module Api
  module V1
    module Concerns
      module Response
        extend ActiveSupport::Concern

        def json_response(object, status = :ok)
          render json: object, status: status
        end
      end
    end
  end
end
