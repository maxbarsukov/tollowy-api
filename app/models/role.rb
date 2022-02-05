class Role < ApplicationRecord
  ROLES = %w[
    banned
    warned
    user
    premium
    primary
    owner
    moderator
    admin
  ].freeze

  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name,
            inclusion: { in: ROLES }

  scopify
end
