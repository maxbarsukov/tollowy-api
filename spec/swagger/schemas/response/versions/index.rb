class Schemas::Response::Versions::Index < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: Schemas::Versions.ref,
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
