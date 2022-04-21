class Schemas::Response::Users::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Users.ref,
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
