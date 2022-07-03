class RemoveDeletedFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :deleted
  end
end
