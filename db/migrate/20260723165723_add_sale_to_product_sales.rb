class AddSaleToProductSales < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_sales, :sale, null: true, foreign_key: true
  end
end
