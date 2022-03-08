class DropActivities < ActiveRecord::Migration[7.0]
  def change
    drop_table :activities
  end
end
