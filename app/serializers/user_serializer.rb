class UserSerializer < ApplicationSerializer
  attributes :email,
             :username,
             :avatar,
             :created_at,
             :updated_at,
             :comments_count,
             :posts_count

  attribute :role do |user|
    RoleSerializer.call(user.role)
  end
end
