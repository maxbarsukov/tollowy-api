class Schemas::Response::Posts::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Posts.ref,
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
