module Api::V1::Concerns::PunditAuthorizer
  extend ActiveSupport::Concern

  private

  def authorize_with_multiple(*args, query, policy)
    pundit_policy = policy.new(current_user, *args)
    return if pundit_policy.public_send(query)

    raise Pundit::NotAuthorizedError,
          query: query,
          record: args.first,
          policy: pundit_policy
  end
end
