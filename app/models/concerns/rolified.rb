module Rolified
  extend ActiveSupport::Concern

  included do
    rolify

    def replace_role(role_before, role_after, resource = nil)
      transaction do
        remove_role role_before, resource
        add_role role_after, resource
      end
    end

    def at_least_a?(role)
      decorate.role.value > Role::HIERARCHY[role]
    end
  end
end
