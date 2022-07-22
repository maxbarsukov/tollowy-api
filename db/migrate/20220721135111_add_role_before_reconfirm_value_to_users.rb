class AddRoleBeforeReconfirmValueToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role_before_reconfirm_value, :integer
  end
end
