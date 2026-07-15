class CreateProductSales < ActiveRecord::Migration[8.0]
  def change
    create_table :product_sales do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 8, scale: 2, null: false
      t.decimal :total_amount, precision: 8, scale: 2, null: false
      t.datetime :sold_at, null: false

      t.timestamps
    end
    add_index :product_sales, :sold_at
  end
end
