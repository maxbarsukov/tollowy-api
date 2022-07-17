class AddOmniAuthDataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :provider_uid, :string

    add_index :users, %i[provider provider_uid], unique: true
  end
end
