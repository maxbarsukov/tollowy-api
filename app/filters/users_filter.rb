class UsersFilter < ApplicationFilter
  FILTERS = {
    username_contains_filter: {
      apply?: ->(params) { params[:username].is_a?(String) },
      apply: ->(scope, params) { scope.where('username ILIKE ?', "%#{params[:username]}%") }
    }.freeze,

    email_contains_filter: {
      apply?: ->(params) { params[:email].is_a?(String) },
      apply: ->(scope, params) { scope.where('email ILIKE %?%', params[:email]) }
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
      :username,
      :email,
      created_at: %i[after before]
    )
  end

  def self.filters
    FILTERS
  end
end
