class Schemas::Response::Votes::Success < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: {
          title: 'Voting success message',
          type: :object,
          properties: {
            type: { type: :string },
            meta: {
              type: :object,
              properties: {
                message: { type: :string }
              }
            }
          },
          required: %w[type meta]
        }
      },
      required: ['data']
    }
  end
end
