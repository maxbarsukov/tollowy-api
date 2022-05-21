class Schemas::Response::Comments::Create < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Comment.ref
      },
      required: ['data']
    }
  end
end
