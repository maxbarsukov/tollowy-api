Pundit.module_eval do
  class << self
    def authorize(user, possibly_namespaced_record, query, policy_class: nil, cache: {})
      record = pundit_model(possibly_namespaced_record)
      policy = if policy_class then policy_class.new(user, record)
               else
                 cache[possibly_namespaced_record] ||= policy!(user, possibly_namespaced_record)
               end

      unless policy.public_send(query)
        raise Auth::BasicAuthError, error_code: policy.error_code,
                                    query:, record:, policy:
      end

      record
    end
  end
end
