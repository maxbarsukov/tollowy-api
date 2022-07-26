class VersionQuery < ApplicationQuery
  default_sort created_at: :desc

  sorts_by :created_at
  sorts_by :v
end
