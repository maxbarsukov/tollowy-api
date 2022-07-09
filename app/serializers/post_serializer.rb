class PostSerializer < ApplicationSerializer
  attributes :body,
             :created_at,
             :updated_at,
             :comments_count,
             :likes_count,
             :dislikes_count,
             :score

  attribute :tag_list do |post|
    post.tags.map(&:name)
  end

  votable!

  belongs_to :user
end
