class Schemas::Response::Comments::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Comments.ref,
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
