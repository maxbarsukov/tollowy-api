class Schemas::Response::Auth::ResendConfirm < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'auth',
        meta: {
          properties: { message: { type: :string } },
          required: %w[message]
        }
      )
    }
  end
end
