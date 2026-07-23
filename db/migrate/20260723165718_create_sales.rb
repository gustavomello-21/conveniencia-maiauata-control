class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :discount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :final_amount, precision: 10, scale: 2, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.datetime :sold_at, null: false
      t.timestamps
    end
  end
end
