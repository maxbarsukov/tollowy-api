class Schemas::Response::Auth::RequestPasswordReset < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'auth',
        meta: {
          properties: {
            message: { type: :string },
            detail: { type: :string }
          },
          required: %w[message detail]
        }
      )
    }
  end
end
