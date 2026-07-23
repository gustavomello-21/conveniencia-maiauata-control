class Sale < ApplicationRecord
  belongs_to :user
  has_many :product_sales, dependent: :destroy

  enum :status, { completed: 0, refunded: 1 }

  validates :total_amount, :discount, :final_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :sold_at, presence: true

  before_validation :set_defaults

  def refund!
    raise "Venda já foi extornada" if refunded?

    transaction do
      product_sales.includes(:product).each do |ps|
        ps.product.with_lock do
          ps.product.increment!(:stock_quantity, ps.quantity)
        end
      end

      refunded!
    end
  end

  private

  def set_defaults
    self.sold_at ||= Time.current
  end
end
