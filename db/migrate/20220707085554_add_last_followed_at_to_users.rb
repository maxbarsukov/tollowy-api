class AddLastFollowedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_followed_at, :datetime
  end
end
