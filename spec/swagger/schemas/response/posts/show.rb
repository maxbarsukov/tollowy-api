class Schemas::Response::Posts::Show < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Post.ref
      },
      required: ['data']
    }
  end
end
