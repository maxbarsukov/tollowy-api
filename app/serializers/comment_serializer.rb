class CommentSerializer < ApplicationSerializer
  attributes :body,
             :user_id,
             :parent_id,
             :commentable_id,
             :child_ids,
             :created_at,
             :edited,
             :edited_at,
             :deleted
end
