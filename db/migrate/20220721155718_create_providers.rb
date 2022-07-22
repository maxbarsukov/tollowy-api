class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :uid, null: false

      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end

    add_index :providers, %i[name uid], unique: true
  end
end
