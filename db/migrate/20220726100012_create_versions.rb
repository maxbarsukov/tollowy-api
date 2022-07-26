class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.string :v, null: false
      t.string :link, null: false
      t.integer :size, null: false
      t.text :whats_new, null: false
      t.string :for_role, null: false, default: 'all'

      t.timestamps
    end

    add_index :versions, :v, unique: true
  end
end
