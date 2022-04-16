class Schemas::Auth < Schemas::Base
  def self.data
    {
      title: 'Auth Data',
      **SwaggerGenerator.generate_data(
        'auth',
        attr: {
          properties: {
            access_token: { type: :string },
            refresh_token: { type: :string },
            me: Schemas::User.ref
          },
          required: %w[access_token refresh_token me]
        }
      )
    }
  end
end
