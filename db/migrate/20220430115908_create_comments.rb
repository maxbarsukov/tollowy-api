class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body

      t.references :user, null: false, foreign_key: true
      t.references :commentable, null: false, index: true, polymorphic: true

      t.boolean :edited, default: false
      t.boolean :deleted, default: false

      t.datetime :edited_at

      t.timestamps null: false
    end
  end
end
