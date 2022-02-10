class AddIndexToPossessionTokensValue < ActiveRecord::Migration[7.0]
  def change
    add_index :possession_tokens, :value, unique: true
  end
end
