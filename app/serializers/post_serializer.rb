class PostSerializer < ApplicationSerializer
  attributes :body,
             :created_at,
             :updated_at,
             :comments_count

  attribute :likes_count, &:cached_votes_up
  attribute :dislikes_count, &:cached_votes_down
  attribute :score, &:cached_votes_score

  meta do |post, params|
    { my_rate: params[:my_rate] || (params[:signed_in] ? post.my_rate : nil) }
  end

  belongs_to :user
end
