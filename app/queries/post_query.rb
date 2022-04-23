class PostQuery < ApplicationQuery
  default_sort created_at: :desc

  sorts_by :body
  sorts_by :created_at
end
