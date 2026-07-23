class AddStatusToSales < ActiveRecord::Migration[8.0]
  def change
    add_column :sales, :status, :integer, default: 0, null: false
  end
end
