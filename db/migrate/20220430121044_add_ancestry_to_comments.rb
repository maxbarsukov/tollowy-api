class AddAncestryToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :ancestry, :string
    add_index :comments, :ancestry
  end
end
