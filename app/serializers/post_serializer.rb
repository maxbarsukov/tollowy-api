class PostSerializer < ApplicationSerializer
  attributes :body, :created_at, :updated_at

  belongs_to :user
end
