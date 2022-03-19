module Api::V1::Concerns::JsonParams
  extend ActiveSupport::Concern

  private

  def json_params(attributes)
    params
      .require(:data)
      .permit(:type, { attributes: attributes })
      .except(:type)[:attributes]
  end
end
