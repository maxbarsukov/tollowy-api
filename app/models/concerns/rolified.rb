module Rolified
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    rolify

    def role
      return @role if defined? @role

      @role = roles.find { |r| r.resource_id.nil? }
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

    def replace_role(role_before, role_after, resource = nil)
      transaction do
        remove_role role_before, resource
        @role = add_role role_after, resource
      end
    end

    def at_least_a?(role)
      return @at_least_a if defined? @at_least_a

      @at_least_a = decorate.role.value >= Role::HIERARCHY[role]
    end

    def suspended?
      return @suspended if defined? @suspended

      @suspended = has_cached_role?(:unconfirmed) || has_cached_role?(:banned)
    end
  end
end
