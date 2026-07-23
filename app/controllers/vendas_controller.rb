class VendasController < ApplicationController
  def index
    @sales = Sale.includes(:user, product_sales: :product).order(sold_at: :desc)
  end

  def new
  end

  def create
    items = JSON.parse(params[:items_json] || "[]")
    discount = params[:discount].to_f

    if items.empty?
      redirect_to new_venda_path, alert: "Adicione pelo menos um produto ao carrinho."
      return
    end

    ActiveRecord::Base.transaction do
      total_amount = 0

      @sale = Sale.new(user: current_user, discount: discount)

      items.each do |item|
        product = Product.find(item["product_id"])
        quantity = item["quantity"].to_i

        product_sale = @sale.product_sales.build(
          product: product,
          quantity: quantity,
          unit_price: product.price,
          total_amount: product.price * quantity,
          sold_at: Time.current
        )

        total_amount += product_sale.total_amount
      end

      @sale.total_amount = total_amount
      @sale.final_amount = [total_amount - discount, 0].max
      @sale.save!
    end

    redirect_to vendas_path, notice: "Venda finalizada com sucesso! Total: R$ #{'%.2f' % @sale.final_amount}"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_venda_path, alert: e.record.errors.full_messages.to_sentence
  rescue JSON::ParserError
    redirect_to new_venda_path, alert: "Dados do carrinho invalidos."
  end

  def refund
    @sale = Sale.find(params[:id])
    @sale.refund!
    redirect_to vendas_path, notice: "Venda ##{@sale.id} extornada com sucesso. Estoque devolvido."
  rescue RuntimeError => e
    redirect_to vendas_path, alert: e.message
  end

  def search
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    products = Product.where("name ILIKE :q OR barcode = :exact", q: "%#{query}%", exact: query)
                      .where("stock_quantity > 0")
                      .order(:name)
                      .limit(10)

    render json: products.map { |p|
      {
        id: p.id,
        name: p.name,
        price: p.price.to_f,
        stock_quantity: p.stock_quantity,
        barcode: p.barcode
      }
    }
  end
end
