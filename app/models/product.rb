class Product < ApplicationRecord
  has_many :product_sales, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def low_stock?
    stock_quantity <= 5
  end
end
