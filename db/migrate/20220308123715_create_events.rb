class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :event, null: false
      t.references :eventable, null: false, index: true, polymorphic: true

      t.timestamps
    end
  end
end
