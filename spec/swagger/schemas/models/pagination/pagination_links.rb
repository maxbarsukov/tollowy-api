class Schemas::PaginationLinks < Schemas::Base
  def self.data
    {
      title: 'Pagination Links',
      description: 'Pagination Links',
      type: :object,
      properties: {
        first: { type: :string },
        self: { type: :string },
        last: { type: :string },
        next: { type: :string },
        prev: { type: :string }
      },
      required: %w[first self last]
    }
  end
end
