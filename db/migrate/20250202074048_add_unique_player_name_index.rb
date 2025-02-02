class AddUniquePlayerNameIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :players, :name, unique: true
  end
end
