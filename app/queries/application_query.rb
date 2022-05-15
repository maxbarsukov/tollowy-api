class ApplicationQuery < Jsonapi::QueryBuilder::BaseQuery
  def initialize(collection, params)
    super(collection, params.to_unsafe_hash)
  end

  # rubocop:disable Performance/MethodObjectAsBlock
  def results
    collection
      .then(&method(:add_includes))
      .then(&method(:sort))
      .then(&method(:filter))
  end
  # rubocop:enable Performance/MethodObjectAsBlock
end
