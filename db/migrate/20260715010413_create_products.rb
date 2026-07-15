class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :stock_quantity, null: false, default: 0

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
