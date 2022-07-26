class Schemas::Response::Versions::Show < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Version.ref
      },
      required: ['data']
    }
  end
end
