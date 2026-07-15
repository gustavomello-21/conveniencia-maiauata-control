# Limpar dados existentes
ProductSale.destroy_all
Product.destroy_all
GameSession.destroy_all

puts "Criando sessões de exemplo..."

# Sessão ativa com bastante tempo
GameSession.create!(
  client_name: "João Silva",
  session_type: :sala_jogos,
  started_at: 45.minutes.ago,
  ends_at: 15.minutes.from_now,
  status: :active
)

# Sessão ativa com pouco tempo (menos de 10 minutos)
GameSession.create!(
  client_name: "Maria Santos",
  session_type: :playstation4,
  started_at: 55.minutes.ago,
  ends_at: 5.minutes.from_now,
  status: :active
)

# Sessão expirada
GameSession.create!(
  client_name: "Pedro Costa",
  session_type: :sala_jogos,
  started_at: 2.hours.ago,
  ends_at: 1.hour.ago,
  status: :expired
)

# Sessão ativa recém iniciada
GameSession.create!(
  client_name: "Ana Paula",
  session_type: :playstation4,
  started_at: 10.minutes.ago,
  ends_at: 50.minutes.from_now,
  status: :active
)

# Sessão finalizada (para histórico)
GameSession.create!(
  client_name: "Carlos Eduardo",
  session_type: :sala_jogos,
  started_at: 3.hours.ago,
  ends_at: 2.hours.ago,
  ended_at: 2.hours.ago,
  renewals_count: 1,
  status: :finished
)

# Mais sessões finalizadas
GameSession.create!(
  client_name: "Juliana Lima",
  session_type: :playstation4,
  started_at: 5.hours.ago,
  ends_at: 4.hours.ago,
  ended_at: 3.hours.ago,
  renewals_count: 2,
  status: :finished
)

GameSession.create!(
  client_name: "Roberto Alves",
  session_type: :sala_jogos,
  started_at: 6.hours.ago,
  ends_at: 5.hours.ago,
  ended_at: 5.hours.ago,
  renewals_count: 0,
  status: :finished
)

puts "Criando produtos de exemplo..."

refrigerante = Product.create!(name: "Refrigerante Lata", price: 5.00, stock_quantity: 24)
agua = Product.create!(name: "Água Mineral", price: 3.00, stock_quantity: 30)
salgadinho = Product.create!(name: "Salgadinho", price: 6.00, stock_quantity: 15)
chocolate = Product.create!(name: "Chocolate", price: 4.00, stock_quantity: 20)

# Algumas vendas de exemplo (reduzem o estoque acima)
refrigerante.product_sales.create!(quantity: 2, sold_at: 1.hour.ago)
agua.product_sales.create!(quantity: 3, sold_at: 40.minutes.ago)
chocolate.product_sales.create!(quantity: 1, sold_at: 20.minutes.ago)

puts "Seeds criadas com sucesso!"
puts "#{GameSession.active.count} sessões ativas"
puts "#{GameSession.expired.count} sessões expiradas"
puts "#{GameSession.finished.count} sessões finalizadas"
puts "#{Product.count} produtos cadastrados"
puts "#{ProductSale.count} vendas de produtos registradas"
