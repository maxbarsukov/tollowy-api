class Schemas::PaginationMeta < Schemas::Base
  def self.data
    {
      title: 'Pagination Meta',
      description: 'Pagination Meta',
      type: :object,
      properties: {
        total: {
          description: 'Total entries',
          type: :integer
        },
        pages: {
          description: 'Total pages count',
          type: :integer
        },
        current_page: {
          description: 'Current page',
          type: :integer
        },
        per_page: {
          description: 'Per Page',
          minimum: 1,
          maximum: Pagy::DEFAULT[:max_per_page],
          type: :integer
        },
        from: {
          description: 'Offset',
          type: :integer
        },
        to: {
          description: 'Offset + Page length',
          type: :integer
        }
      },
      required: %w[total pages current_page per_page from to]
    }
  end
end
