class RelatoriosController < ApplicationController
  before_action :require_admin

  def index
    # Filtrar por data se especificado
    date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    start_of_day = date.beginning_of_day
    end_of_day = date.end_of_day

    sessions_today = GameSession.where(started_at: start_of_day..end_of_day)
    product_sales_today = ProductSale.where(sold_at: start_of_day..end_of_day)
                                     .left_joins(:sale)
                                     .where("sale_id IS NULL OR sales.status = ?", Sale.statuses[:completed])

    # Total de clientes
    @total_clients = sessions_today.count

    # Faturamento de sessões e de produtos
    @session_revenue = sessions_today.sum(:amount_paid)
    @product_revenue = product_sales_today.sum(:total_amount)
    @total_revenue = @session_revenue + @product_revenue

    # Faturamento por tipo de sessão
    @revenue_by_type = sessions_today.group(:session_type).sum(:amount_paid)

    # Vendas de produtos: quantidade e faturamento por produto
    @product_sales_by_product = product_sales_today.joins(:product)
                                                     .group("products.name")
                                                     .order("products.name")
                                                     .select("products.name AS product_name",
                                                             "SUM(product_sales.quantity) AS total_quantity",
                                                             "SUM(product_sales.total_amount) AS total_amount")

    # Média de renovações
    @avg_renewals = sessions_today.average(:renewals_count).to_f.round(2)

    # Total de renovações
    @total_renewals = sessions_today.sum(:renewals_count)

    # Sessões ativas no momento
    @active_sessions = GameSession.active.count

    @selected_date = date
  end
end
