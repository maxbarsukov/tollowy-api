class ApplicationQuery < Jsonapi::QueryBuilder::BaseQuery
  def initialize(collection, params)
    super(collection, params.to_unsafe_hash)
  end
end
