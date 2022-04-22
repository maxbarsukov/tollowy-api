class ApplicationQuery < Jsonapi::QueryBuilder::BaseQuery
  def initialize(collection, params)
    super(collection, params.to_unsafe_hash)
  end

  def results
    collection
      .yield_self(&method(:add_includes))
      .yield_self(&method(:sort))
      .yield_self(&method(:filter))
  end
end
