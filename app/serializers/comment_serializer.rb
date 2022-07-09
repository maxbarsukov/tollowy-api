class CommentSerializer < ApplicationSerializer
  attributes :body,
             :user_id,
             :commentable_id,
             :commentable_type,
             :created_at,
             :edited_at,
             :edited,
             :likes_count,
             :dislikes_count,
             :score

  votable!
end
