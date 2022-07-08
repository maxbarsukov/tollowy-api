class AddFollowersCountToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :following_tags_count, :integer, null: false, default: 0

    add_column :tags, :followers_count, :integer, null: false, default: 0
  end
end
