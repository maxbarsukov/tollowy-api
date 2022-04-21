class Schemas::Response::Auth::SignOut < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'auth',
        meta: {
          properties: {
            message: { type: :string }
          },
          required: ['message']
        }
      )
    }
  end
end
