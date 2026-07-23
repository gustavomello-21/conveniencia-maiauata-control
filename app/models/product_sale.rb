class ProductSale < ApplicationRecord
  belongs_to :product
  belongs_to :sale, optional: true

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validate :quantity_within_stock

  before_validation :set_defaults

  after_create :decrement_product_stock

  private

  def set_defaults
    self.sold_at ||= Time.current
    self.unit_price ||= product&.price
    self.total_amount = unit_price.to_f * quantity.to_i if unit_price && quantity
  end

  def quantity_within_stock
    return if product.nil? || quantity.nil?
    errors.add(:quantity, "maior que o estoque disponível (#{product.stock_quantity} un.)") if quantity > product.stock_quantity
  end

  def decrement_product_stock
    product.with_lock do
      product.update!(stock_quantity: product.stock_quantity - quantity)
    end
  end
end
