class PostQuery < ApplicationQuery
  default_sort created_at: :desc

  sorts_by :body
  sorts_by :score
  sorts_by :likes_count
  sorts_by :dislikes_count
  sorts_by :created_at
end
