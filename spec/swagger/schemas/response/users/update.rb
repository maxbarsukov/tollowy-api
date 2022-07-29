class Schemas::Response::Users::Update < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::User.ref,
        meta: {
          type: :object,
          properties: {
            message: { type: :string }
          },
          required: %w[message]
        }
      },
      required: %w[data meta]
    }
  end
end
