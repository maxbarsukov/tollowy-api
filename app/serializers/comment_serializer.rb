class CommentSerializer < ApplicationSerializer
  attributes :body,
             :user_id,
             :commentable_id,
             :created_at,
             :edited_at,
             :edited
end
