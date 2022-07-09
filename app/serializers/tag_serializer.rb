class TagSerializer < ApplicationSerializer
  attributes :name,
             :created_at,
             :updated_at,
             :followers_count,
             :taggings_count

  followable!
end
