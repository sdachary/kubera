# Kubera Architecture

## Overview

Kubera is a Rails 7.2 application with a ViewComponent + Tailwind CSS frontend. It follows a debt-first financial philosophy: **Negative → Zero → Positive**.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Rails 7.2 (API + server-rendered views) |
| Database | PostgreSQL (via sqlite3 in dev) |
| Frontend | ViewComponents + Tailwind CSS + Stimulus + Turbo |
| Background | Sidekiq (Redis) |
| Auth | BCrypt/Argon2 + OAuth 2.0 (Doorkeeper) |
| AI | OpenAI-compatible API (OpenRouter, Ollama, Claude) |
| Testing | RSpec + FactoryBot + SimpleCov |

## Directory Structure

```
kubera/
├── app/
│   ├── components/       # ViewComponents (Sidebar, Debt, Portfolio, etc.)
│   ├── controllers/      # Rails controllers + API::V1 namespace
│   ├── javascript/       # Stimulus controllers
│   ├── jobs/             # ActiveJob base classes
│   ├── mailers/          # ActionMailer classes
│   ├── models/           # ActiveRecord models
│   ├── services/         # Business logic services
│   │   ├── providers/    # Market data adapters (Yahoo Finance, etc.)
│   ├── views/            # ERB templates
│   └── workers/          # Sidekiq workers
├── config/               # Rails config + tailwind.config.js
├── db/
│   ├── migrate/          # Squashed initial migration
│   │   └── archive/      # Archived per-change migrations
│   └── schema.rb         # Current database schema
├── lib/                  # Custom libraries (Money, generators)
├── docs/                 # Architecture docs
└── packages/
    └── kubera-ui/        # Design tokens (colors, typography, spacing)
```

## Key Services

### Debt Payoff (`DebtPayoffService`)
Implements Avalanche (highest interest first) and Snowball (lowest balance first) strategies. Generates month-by-month payoff schedules.

### Dividend SIP (`DividendSipService`, `DividendScreenerService`)
Screens dividend stocks via Yahoo Finance API. Allocates investments using weighted scoring (yield 60%, growth 40%).

### Portfolio Optimization (`PortfolioService`)
Calculates optimal asset weights, expected return, volatility, and Sharpe ratio using Modern Portfolio Theory.

### Wealth Journey (`WealthJourneyTracker`)
12-month net worth projection + 30-year wealth growth model. Computes debt-free (zero-day) milestone.

### Market Data (`Providers::YahooFinanceAdapter`)
Fetches real-time quotes, dividend data, and exchange rates from Yahoo Finance (free, no API key). Pluggable architecture supports Twelve Data and Alpha Vantage.

## Data Flow

```
User → Rails Controller → Service Object → Model → PostgreSQL
                                ↕
                        Market Data Provider
                        (Yahoo Finance API)
                                ↕
                        Sidekiq Worker
                        (ImportMarketDataWorker)
```

## Frontend Architecture

- **ViewComponents** render all app UI (debt cards, portfolio dashboard, SIP calculator)
- **Tailwind CSS** with custom `kubera/` color palette for theming
- **Stimulus controllers** handle interactivity (clipboard, form behaviors)
- **Turbo** enables SPA-like navigation without writing JavaScript
- Dark mode via `class` strategy with CSS custom properties

## Background Jobs

| Worker | Schedule | Purpose |
|--------|----------|---------|
| `ImportMarketDataWorker` | Weekdays 5PM EST | Refresh security prices after market close |
| `SyncCleanerJob` | Every hour | Clean stale sync records |
| `SecurityHealthCheckJob` | Weekdays 2AM EST | Verify security data integrity |
| `DataCleanerJob` | Daily 3AM | Purge expired associations and exports |

## Design Tokens

Design tokens (colors, typography, spacing) are defined in two places:
1. `packages/kubera-ui/src/theme/` — JavaScript source of truth
2. `config/tailwind.config.js` — Tailwind CSS integration
3. `app/views/layouts/application.html.erb` — CSS custom properties for runtime theming

## Configuration

Key environment variables (see `.env.example`):
- `SECURITIES_PROVIDER`: Market data backend (default: `yahoo_finance`)
- `EXCHANGE_RATE_PROVIDER`: Exchange rate backend (default: `yahoo_finance`)
- `OPENAI_*`: AI assistant configuration
- `SMTP_*`: Email delivery settings
