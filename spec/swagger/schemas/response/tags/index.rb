class Schemas::Response::Tags::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Tags.ref,
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
