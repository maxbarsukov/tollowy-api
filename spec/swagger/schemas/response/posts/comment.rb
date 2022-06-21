class Schemas::Response::Posts::Comment < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: {
          type: :array,
          items: Schemas::Comment.ref
        },
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: %w[data links meta]
    }
  end
end
