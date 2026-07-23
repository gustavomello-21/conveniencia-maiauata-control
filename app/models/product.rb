class Product < ApplicationRecord
  has_many :product_sales, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, uniqueness: true, allow_blank: true

  def low_stock?
    stock_quantity <= 5
  end
end
