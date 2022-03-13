class UserSerializer < ApplicationSerializer
  attributes :email, :username, :created_at

  attribute :role do |user|
    RoleSerializer.call(user.role)
  end
end
