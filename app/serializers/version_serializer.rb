class VersionSerializer < ApplicationSerializer
  attributes :v,
             :link,
             :size,
             :for_role,
             :whats_new
end
