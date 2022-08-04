class CreateIpAddresses < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :ip_addresses do |t|
      t.inet :ip, null: false

      t.references :user, foreign_key: true
      t.integer :user_sign_in_count, default: 0, null: false

      t.boolean :blocked, default: false, null: false

      t.timestamps
    end

    add_index :ip_addresses, :ip, using: :gist, opclass: :inet_ops, algorithm: :concurrently
    add_index :ip_addresses, :blocked, where: 'blocked', using: :btree, algorithm: :concurrently
  end
end
