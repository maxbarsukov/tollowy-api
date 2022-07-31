class RoleFixture < ApplicationFixture
  seed do
    roles = []

    Role::MAIN_ROLES.each_with_index do |role_name, ind|
      puts "#{ind}:\tRole(#{role_name})"
      roles << Role.new(name: role_name)
    end

    import roles
  end
end
