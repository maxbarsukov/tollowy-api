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

  meta do |post, params|
    { my_rate: params[:my_rate] || (params[:signed_in] ? post.my_rate : nil) }
  end
end
