class Schemas::Response::Posts::Show < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Post.ref,
        meta: {
          type: :object,
          properties: {
            my_rate: { type: :integer, nullable: true }
          }
        }
      },
      required: ['data']
    }
  end
end
