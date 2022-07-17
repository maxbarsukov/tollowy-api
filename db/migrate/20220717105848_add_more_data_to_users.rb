class AddMoreDataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :blog, :string
    add_column :users, :location, :string
  end
end
