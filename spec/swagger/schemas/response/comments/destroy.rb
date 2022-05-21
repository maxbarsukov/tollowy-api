class Schemas::Response::Comments::Destroy < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            type: { type: :string },
            meta: {
              type: :object,
              properties: {
                message: { type: :string }
              },
              required: ['message']
            }
          },
          required: %w[type meta]
        }
      },
      required: ['data']
    }
  end
end
