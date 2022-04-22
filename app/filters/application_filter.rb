class ApplicationFilter
  def self.filters
    {}.freeze
  end

  def call(scope, params)
    apply_filters!(self.class.filters.keys, scope, filter_params(params))
  end

  protected

  def filter_params(params)
    params
  end

  private

  def apply_filters!(filter_keys, scope, params)
    filter_keys.inject(scope.dup) do |current_scope, filter_key|
      apply_filter!(filter_key, current_scope, params)
    end
  end

  def apply_filter!(filter_key, scope, params)
    filter = fetch_filter(filter_key)
    return scope unless apply_filter?(filter, params)

    filter[:apply].call(scope, params)
  end

  def apply_filter?(filter, params)
    filter[:apply?].call(params)
  end

  def fetch_filter(filter_key)
    self.class.filters.fetch(filter_key) { raise ArgumentError, 'unknown filter' }
  end
end
