class UserFollowableSerializer < ApplicationSerializer
  set_type :user

  attributes :email,
             :username,
             :avatar,
             :created_at,
             :updated_at,
             :comments_count,
             :posts_count,
             :followers_count,
             :follow_count,
             :following_users_count,
             :following_tags_count,
             :last_followed_at

  meta do |_tag, params|
    { followed_at: params[:followed_at] }
  end
end
