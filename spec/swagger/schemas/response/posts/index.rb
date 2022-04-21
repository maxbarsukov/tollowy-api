class Schemas::Response::Posts::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Posts.ref
      },
      required: ['data']
    }
  end
end
