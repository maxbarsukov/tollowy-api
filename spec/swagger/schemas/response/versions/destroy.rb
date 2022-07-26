class Schemas::Response::Versions::Destroy < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'version',
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
