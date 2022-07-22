class RemoveProviderFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, name: :index_users_on_provider_and_provider_uid

    remove_column :users, :provider
    remove_column :users, :provider_uid
  end
end
