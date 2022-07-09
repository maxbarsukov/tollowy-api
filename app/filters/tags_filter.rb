class TagsFilter < ApplicationFilter
  FILTERS = {
    name_contains_filter: {
      apply?: ->(params) { params[:name].is_a?(String) },
      apply: ->(scope, params) { scope.where('tags.name ILIKE ?', "%#{params[:name]}%") }
    }.freeze,

    updated_at_before_filter: {
      apply?: ->(params) { params.dig(:updated_at, :before).is_a?(String) },
      apply: ->(scope, params) { scope.where('tags.updated_at <= ?', params.dig(:updated_at, :before)) }
    }.freeze,

    updated_at_after_filter: {
      apply?: ->(params) { params.dig(:updated_at, :after).is_a?(String) },
      apply: ->(scope, params) { scope.where('tags.updated_at >= ?', params.dig(:updated_at, :after)) }
    }.freeze
  }.freeze

  def filter_params(params)
    params.fetch(:filter, {}).permit(
      :name,
      updated_at: %i[after before]
    )
  end

  def self.filters
    FILTERS
  end
end
