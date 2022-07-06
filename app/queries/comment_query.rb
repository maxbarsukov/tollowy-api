class CommentQuery < ApplicationQuery
  default_sort created_at: :asc

  sorts_by :created_at
end
