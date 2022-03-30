# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
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
      HIERARCHY.forward.value?(arg) ? arg : (raise Roles::UnexpectedRoleTypeError)
    when Symbol, String
      Role.value_by_name(arg.to_sym)
    when Role
      arg.value
    else
      raise Roles::UnexpectedRoleTypeError
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
      raise Roles::UnexpectedRoleTypeError
    end
  end

  def self.value_by_name(sym)
    res = Role::HIERARCHY[sym]
    raise Roles::UndefinedRoleTypeError.new(role_type: sym) unless res

    res
  end
end
