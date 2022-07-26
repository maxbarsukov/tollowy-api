module Api::V1::Concerns::PunditAuthorizer
  extend ActiveSupport::Concern

  private

  def authorize_with_multiple(*args, query, policy)
    pundit_policy = policy.new(current_user, *args)
    return if pundit_policy.public_send(query)

    raise Auth::NotAuthorizedError,
          error_code: pundit_policy&.error_code || :unauthorized,
          message: pundit_policy.error_message,
          query:,
          record: args.first,
          policy: pundit_policy
  end

  def authorize_with_error(record, query = nil, policy_class: nil)
    query ||= "#{action_name}?"

    record = Pundit.send(:pundit_model, record)
    policy = policy_class.present? ? policy_class.new(current_user, record) : Pundit.policy!(current_user, record)

    unless policy.public_send(query)
      raise Auth::NotAuthorizedError,
            error_code: policy&.error_code || :unauthorized,
            message: policy.error_message,
            query:, record:, policy:
    end

    record
  end
end
