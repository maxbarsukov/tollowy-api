class UserSerializer < ApplicationSerializer
  attributes :email,
             :username,
             :bio,
             :blog,
             :location,
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

  attribute :role do |user|
    RoleSerializer.call(user.role)
  end

  followable!
end
