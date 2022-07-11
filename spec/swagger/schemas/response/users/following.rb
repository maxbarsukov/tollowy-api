class Schemas::Response::Users::Following < Schemas::Base
  def self.data
    {
      type: :object,
      properties: {
        data: {
          type: :array,
          item: {
            type: {
              oneOf: [
                Schemas::UserSmall.ref,
                Schemas::TagSmall.ref
              ]
            }
          }
        },
        links: Schemas::PaginationLinks.ref,
        meta: Schemas::PaginationMeta.ref
      },
      required: ['data']
    }
  end
end
