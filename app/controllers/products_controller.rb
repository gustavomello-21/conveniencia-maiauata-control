class ProductsController < ApplicationController
  def index
    @products = Product.order(:name)
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Produto cadastrado: #{@product.name}"
    else
      @products = Product.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def sell
    @product = Product.find(params[:id])
    sale = @product.product_sales.new(quantity: params[:quantity].to_i)

    if sale.save
      redirect_to products_path, notice: "Venda registrada: #{sale.quantity}x #{@product.name}"
    else
      redirect_to products_path, alert: sale.errors.full_messages.to_sentence
    end
  end

  def restock
    @product = Product.find(params[:id])
    quantity = params[:quantity].to_i

    if quantity > 0
      @product.increment!(:stock_quantity, quantity)
      redirect_to products_path, notice: "Estoque atualizado: +#{quantity} #{@product.name}"
    else
      redirect_to products_path, alert: "Quantidade inválida"
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :stock_quantity)
  end
end
