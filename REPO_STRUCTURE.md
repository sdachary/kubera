# Kubera Repository Structure

## Overview
Kubera is a **single-repo** Rails 7.2 application:
- Rails backend with ViewComponents (no React)
- Tailwind CSS for styling (design tokens from `tailwind.config.js`)
- Importmap for JavaScript (no bundler)
- PostgreSQL + Redis + Sidekiq for background jobs

## Directory Structure

```
kubera/                    # Single repo (github.com/deepakachary/kubera)
├── app/
│   ├── controllers/       # PagesController + Api::V1 namespace
│   │   └── api/v1/        # debt_payoff, dividend_sip, portfolio, journey, etc.
│   ├── models/            # Debt, RecurringExpense, Portfolio, User, etc.
│   ├── services/          # DebtPayoffService, DividendScreener, PortfolioService
│   │   └── providers/     # YahooFinanceAdapter
│   ├── components/        # ViewComponents (Sidebar, Debt::Card, SIPCalculator, etc.)
│   ├── views/             # ERB templates + mailer views
│   ├── javascript/        # Stimulus controllers (importmap-based)
│   ├── mailers/           # NotificationMailer
│   └── workers/           # Sidekiq workers (ImportMarketData, SyncCleaner, etc.)
├── config/                # Rails configuration
├── db/migrate/            # Single squashed migration (20260508000000)
├── docs/                  # Documentation + ARCHITECTURE.md
├── spec/                  # RSpec tests (models, services, requests)
├── compose.yml            # Docker Compose (web + worker + postgres + redis)
├── Dockerfile             # Multi-stage container definition
└── .github/workflows/     # CI + deploy pipelines
```

## Development Workflow

### Local Development
```bash
bin/dev
# Or with Docker
docker compose up --build
```

### Testing
```bash
bundle exec rspec
bundle exec rubocop
```

## Current API Endpoints

| Prefix | Controller | Actions |
|--------|-----------|---------|
| `/api/v1/debt_payoffs` | DebtPayoffController | index, create, show, update, destroy, simulate |
| `/api/v1/dividend_sips` | DividendSipController | index, create, show, update, destroy, suggest |
| `/api/v1/portfolios` | PortfolioController | index, create, show, update, destroy, rebalance |
| `/api/v1/journey` | JourneyController | show, progress, net_worth, projection, snapshot |
| `/api/v1/net_worth_snapshots` | NetWorthSnapshotsController | index, show |
| `/api/v1/recurring_expenses` | RecurringExpensesController | index, create, show, update, destroy, calendar |

## Core Principles
- **Privacy-first**: All data stays on the user's machine (no cloud sync)
- **Zero-config**: Docker Compose for full stack deployment
- **Local AI**: Optional OpenRouter/Ollama integration for financial insights
