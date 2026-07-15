# Conveniência Maiauatá - Sistema de Gestão de Sessões de Jogos

Sistema completo para gerenciar sessões de tempo em espaços de jogos (LAN house/gaming space). Permite que o recepcionista inicie, renove e encerre sessões de clientes, com monitoramento em tempo real via tela pública (TV).

## Funcionalidades

- **Painel do Recepcionista**: Gerenciamento completo de sessões (criar, renovar, encerrar)
- **Tela da TV**: Display público em tempo real das sessões ativas
- **Histórico**: Consulta de sessões finalizadas com filtros por data
- **Relatórios**: Estatísticas de faturamento e uso
- **Atualização em Tempo Real**: Via Turbo Streams (ActionCable)
- **Contagem Regressiva**: Atualização automática do tempo restante
- **Alertas Visuais**: Cores diferentes baseadas no tempo restante
- **Job Automático**: Verifica e marca sessões expiradas a cada 30 segundos

## Tipos de Sessão

- **Geral**: R$ 5,00 por hora
- **Play 4**: R$ 7,00 por hora

## Requisitos

- Ruby 3.3.0
- Rails 8.0.5
- PostgreSQL 14+
- Node.js (para importmap)

## Instalação

1. Clone o repositório:
```bash
git clone <repository-url>
cd play-control
```

2. Instale as dependências:
```bash
bundle install
```

3. Configure o banco de dados:
```bash
# Certifique-se de que o PostgreSQL está rodando
brew services start postgresql@14

# Crie e configure o banco
rails db:create
rails db:migrate
rails db:seed
```

4. Compile o CSS:
```bash
rails tailwindcss:build
```

5. Inicie o servidor:
```bash
rails server
# ou
bin/dev
```

## Uso

### Painel do Recepcionista
Acesse: `http://localhost:3000`

- Criar nova sessão: Preencha o nome do cliente e selecione o tipo
- Renovar sessão: Clique em "Renovar +1h" para adicionar uma hora
- Encerrar sessão: Clique em "Encerrar" para finalizar a sessão

### Tela da TV
Acesse: `http://localhost:3000/tv`

- Abra em uma nova aba/janela
- Exibe sessões ativas em cards grandes
- Cores:
  - Verde: Mais de 10 minutos restantes
  - Amarelo: Menos de 10 minutos restantes
  - Vermelho piscando: Sessão expirada
- Atualiza automaticamente em tempo real

### Histórico
Acesse: `http://localhost:3000/historico`

- Visualize todas as sessões finalizadas
- Filtro por período (data inicial e final)
- Informações: duração real, renovações, valor pago

### Relatórios
Acesse: `http://localhost:3000/relatorios`

- Estatísticas do dia selecionado
- Faturamento total e por tipo
- Total de clientes
- Média de renovações
- Sessões ativas no momento

## Estrutura do Projeto

```
app/
├── controllers/
│   ├── sessions_controller.rb    # Gerenciamento de sessões
│   ├── tv_controller.rb           # Tela pública da TV
│   ├── historico_controller.rb    # Histórico de sessões
│   └── relatorios_controller.rb   # Relatórios e estatísticas
├── models/
│   └── game_session.rb            # Model principal
├── views/
│   ├── sessions/                  # Views do painel
│   ├── tv/                        # Views da TV
│   ├── historico/                 # Views do histórico
│   └── relatorios/                # Views dos relatórios
├── javascript/
│   └── controllers/
│       └── countdown_controller.js # Stimulus para contagem regressiva
└── jobs/
    └── expire_sessions_job.rb     # Job para expirar sessões
```

## Tecnologias Utilizadas

- **Ruby on Rails 8**: Framework principal
- **PostgreSQL**: Banco de dados
- **Hotwire (Turbo + Stimulus)**: Interatividade e tempo real
- **Tailwind CSS**: Estilização
- **ActionCable**: WebSockets para broadcast em tempo real
- **Solid Queue**: Processamento de jobs

## Broadcast em Tempo Real

O sistema utiliza Turbo Streams para atualizar automaticamente:

1. **Painel do recepcionista**: Quando sessões são criadas, renovadas ou encerradas
2. **Tela da TV**: Sincronizada com o painel
3. **Job automático**: Atualiza status de sessões expiradas

## Job Recorrente

O arquivo `config/initializers/scheduler.rb` executa o job `ExpireSessionsJob` a cada 30 segundos para verificar e marcar sessões expiradas.

## Configurações

### Timezone
Configurado para `America/Sao_Paulo` em `config/application.rb`

### Valores das Sessões
Definidos no model `GameSession`:
- Geral: R$ 5,00
- Play 4: R$ 7,00

Para alterar, edite o método `set_initial_values` em `app/models/game_session.rb`

## Desenvolvimento

### Executar Console
```bash
rails console
```

### Executar Migrations
```bash
rails db:migrate
```

### Resetar Banco de Dados
```bash
rails db:reset
```

### Ver Rotas
```bash
rails routes
```

## Produção

Para deploy em produção, certifique-se de:

1. Configurar variáveis de ambiente para o banco de dados
2. Precompilar assets: `rails assets:precompile`
3. Configurar ActionCable para usar Redis
4. Configurar Solid Queue para processamento de jobs

## Licença

Este projeto é de uso interno.
