class AddAncestryDepthToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :ancestry_depth, :integer, default: 0
    add_column :comments, :children_count, :integer, default: 0
    Comment.rebuild_depth_cache!
  end
end
