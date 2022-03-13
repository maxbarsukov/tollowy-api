class Role < ApplicationRecord
  HIERARCHY = Bihash[{
    unconfirmed: -30,
    banned: -20,
    warned: -10,
    user: 0,
    premium: 10,
    primary: 20,
    owner: 30,
    moderator: 40,
    admin: 50
  }].freeze

  ROLES = Role::HIERARCHY.forward.keys.map(&:to_s).freeze

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

  scope :global, -> { where(resource_type: nil) }
  scope :resourced, -> { where.not(resource_type: nil) }

  def value
    HIERARCHY[name.to_sym]
  end
end
