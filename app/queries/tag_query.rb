class TagQuery < ApplicationQuery
  default_sort updated_at: :desc

  sorts_by :name
  sorts_by :taggings_count
  sorts_by :followers_count
  sorts_by :updated_at
end
