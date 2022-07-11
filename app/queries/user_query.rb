class UserQuery < ApplicationQuery
  default_sort created_at: :desc

  sorts_by :username
  sorts_by :email
  sorts_by :created_at

  sorts_by :follow_count
  sorts_by :followers_count
end
