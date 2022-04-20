class Schemas::PaginationError < Schemas::Base
  def self.data
    {
      **Schemas::Error.data,
      title: 'Pagination Error',
      description: 'JSON:API Pagination Error response'
    }.tap do |error|
      error[:properties][:errors][:items][:properties].merge!(
        {
          source: {
            parameter: { type: :string }
          }
        }
      )
    end
  end
end
