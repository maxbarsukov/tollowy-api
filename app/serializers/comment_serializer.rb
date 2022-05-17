class CommentSerializer < ApplicationSerializer
  attributes :body,
             :user_id,
             :commentable_id,
             :parent_id,
             :child_ids,
             :created_at,
             :edited_at,
             :edited,
             :deleted
end
