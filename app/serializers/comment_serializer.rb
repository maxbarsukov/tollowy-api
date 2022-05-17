class CommentSerializer < ApplicationSerializer
  attributes :body,
             :user_id,
             :commentable_id,
             :parent_id,
             :created_at,
             :edited_at,
             :edited,
             :deleted

  meta do |comment|
    {
      children_count: comment.children_count
    }
  end
end
