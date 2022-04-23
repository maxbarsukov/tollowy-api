class PostsFilter < ApplicationFilter
  FILTERS = {
    body_contains_filter: {
      apply?: ->(params) { params[:body].is_a?(String) },
      apply: ->(scope, params) { scope.where('body ILIKE ?', "%#{params[:body]}%") }
    }.freeze,

    created_at_before_filter: {
      apply?: ->(params) { params.dig(:created_at, :before).is_a?(String) },
      apply: ->(scope, params) { scope.where('created_at <= ?', params.dig(:created_at, :before)) }
    }.freeze,

    created_at_after_filter: {
      apply?: ->(params) { params.dig(:created_at, :after).is_a?(String) },
      apply: ->(scope, params) { scope.where('created_at >= ?', params.dig(:created_at, :after)) }
    }.freeze
  }.freeze

  def filter_params(params)
    params.fetch(:filter, {}).permit(
      :body,
      created_at: %i[after before]
    )
  end

  def self.filters
    FILTERS
  end
end
