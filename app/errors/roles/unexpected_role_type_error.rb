class Roles::UnexpectedRoleTypeError < StandardError
  def initialize(msg = nil, role_type: nil)
    super(msg || "Unexpected role type: #{role_type}")
  end
end
