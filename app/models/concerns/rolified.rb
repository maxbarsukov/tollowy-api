module Rolified
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    rolify

    def role
      roles.find { |r| r.resource_id.nil? }
    end

    def role=(new_role)
      case new_role
      when Symbol, String
        update_role(new_role.to_sym)
      when Numeric
        update_role(Role::HIERARCHY[new_role])
      else
        raise ArgumentError, "Unexpected new_role type: #{new_role}"
      end
    end

    def update_role(new_role)
      transaction do
        remove_role role.name.to_sym
        add_role new_role
      end
    end

    def replace_role(role_before, role_after, resource = nil)
      transaction do
        remove_role role_before, resource
        add_role role_after, resource
      end
    end

    def at_least_a?(role)
      decorate.role.value > Role::HIERARCHY[role]
    end

    def is_suspended?
      is_unconfirmed? || is_banned?
    end
  end
end
