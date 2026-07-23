class AddCostPriceAndBarcodeToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :cost_price, :decimal, precision: 8, scale: 2
    add_column :products, :barcode, :string
    add_index :products, :barcode, unique: true
  end
end
