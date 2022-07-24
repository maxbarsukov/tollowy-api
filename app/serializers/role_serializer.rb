class RoleSerializer < ApplicationSerializer
  attributes :name,
             :value,
             :resource_type,
             :resource_id
end
