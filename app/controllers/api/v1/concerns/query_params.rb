module Api::V1::Concerns::QueryParams
  extend ActiveSupport::Concern

  private

  def query_params
    params.permit(:sort, :include)
  end
end
