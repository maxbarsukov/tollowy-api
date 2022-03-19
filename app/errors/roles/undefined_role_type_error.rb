class Roles::UndefinedRoleTypeError < StandardError
  def initialize(msg = nil, role_type: nil)
    super(msg || "Undefined role type: #{role_type}")
  end
end
