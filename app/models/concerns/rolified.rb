module Rolified
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    rolify

    def role
      return @role if defined? @role

      @role = roles.find { |r| r.resource_id.nil? && r.resource_type.nil? }
    end

    delegate :value, to: :role, prefix: true

    def role_value=(new_role)
      self.role = (new_role.to_i)
    end

    def role=(new_role)
      case new_role
      when Symbol, String
        @role = update_role(new_role.to_sym)
      when Numeric
        @role = update_role(Role::HIERARCHY[new_role])
      else
        raise ArgumentError, "Unexpected new_role type: #{new_role}"
      end
    end

    def update_role(new_role)
      transaction do
        remove_role role.name.to_sym if role
        @role = add_role new_role
      end
    end

    def at_least_a?(role)
      decorate.role.value >= Role::HIERARCHY[role]
    end

    def suspended?
      has_cached_role?(:unconfirmed) || has_cached_role?(:banned)
    end

    def admin? = at_least_a?(:admin)

    def moderator? = at_least_a?(:moderator)

    def dev? = at_least_a?(:moderator)
  end
end
