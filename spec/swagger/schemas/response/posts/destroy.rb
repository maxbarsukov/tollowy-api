class Schemas::Response::Posts::Destroy < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'post',
        meta: {
          properties: {
            message: { type: :string }
          },
          required: %w[message]
        }
      )
    }
  end
end
