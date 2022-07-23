class Schemas::Response::Auth::Provider < Schemas::Base
  def self.data
    {
      title: 'Provider Auth Data and message',
      **SwaggerGenerator.generate_data(
        'auth',
        attr: {
          properties: {
            access_token: { type: :string },
            refresh_token: { type: :string },
            me: Schemas::User.ref
          },
          required: %w[access_token refresh_token me]
        },
        meta: {
          message: { type: :string }
        }
      )
    }
  end
end
