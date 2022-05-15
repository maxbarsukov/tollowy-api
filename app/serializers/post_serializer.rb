class PostSerializer < ApplicationSerializer
  attributes :body,
             :created_at,
             :updated_at,
             :comments_count

  belongs_to :user
end
