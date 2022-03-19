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

  def value
    HIERARCHY[name.to_sym]
  end

  def self.value_for(arg)
    case arg
    when Numeric
      arg
    when Symbol, String
      Role.value_by_name(arg.to_sym)
    when Role
      arg.value
    else
      raise ArgumentError, "Unexpected role type: #{arg}"
    end
  end

  def self.symbol_name_for(arg)
    case arg
    when Symbol, String
      arg.to_sym
    when Numeric
      Role::HIERARCHY[arg]
    when Role
      arg.name.to_sym
    else
      raise ArgumentError, "Unexpected role type: #{arg}"
    end
  end

  def self.value_by_name(sym)
    res = Role::HIERARCHY[sym]
    raise Roles::UndefinedRoleTypeError.new(role_type: sym) unless res

    res
  end
end
