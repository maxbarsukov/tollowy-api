class Schemas::Response::Auth::Confirm < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'auth',
        attr: {
          properties: { me: Schemas::User.ref },
          required: ['me']
        }
      )
    }
  end
end
