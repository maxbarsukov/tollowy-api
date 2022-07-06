class PostSerializer < ApplicationSerializer
  attributes :body,
             :created_at,
             :updated_at,
             :comments_count,
             :likes_count,
             :dislikes_count,
             :score

  meta do |post, params|
    { my_rate: params[:my_rate] || (params[:signed_in] ? post.my_rate : nil) }
  end

  belongs_to :user
end
