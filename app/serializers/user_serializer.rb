class UserSerializer < ApplicationSerializer
  attributes :email,
             :username,
             :avatar,
             :created_at,
             :updated_at,
             :comments_count,
             :posts_count,
             :followers_count,
             :follow_count,
             :last_followed_at

  attribute :role do |user|
    RoleSerializer.call(user.role)
  end
end
