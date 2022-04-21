class Schemas::Response::Users::Show < Schemas::Base
  def self.data
    {
      type: :object,
      properties: { data: Schemas::User.ref },
      required: ['data']
    }
  end
end
