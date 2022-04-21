class Schemas::Response::Root::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        message: { type: :string, enum: ["If you see this, you're in!"] }
      },
      required: ['message']
    }
  end
end
