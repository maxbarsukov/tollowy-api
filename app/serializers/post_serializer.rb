class PostSerializer < ApplicationSerializer
  attributes :body, :user_id, :created_at, :updated_at

  belongs_to :user
end
