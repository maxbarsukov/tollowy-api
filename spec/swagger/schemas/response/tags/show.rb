class Schemas::Response::Tags::Show < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Tag.ref
      },
      required: ['data']
    }
  end
end
