# Kubera Repository Structure

## Overview
Kubera is a **single-repo** application:
- Rails API backend with ViewComponents (in `app/`)
- Vite React landing page (at root, `src/`)
- All features native, no external fork dependencies

## Directory Structure

```
kubera/                    # Single repo (github.com/deepakachary/kubera)
├── app/                  # Rails application
│   ├── controllers/     # API: /api/v1/debt_payoff, dividend_sip, portfolio, journey
│   ├── models/          # Loan, RecurringExpense, Account, etc.
│   ├── services/        # DebtPayoffCalculator, DividendScreener, PortfolioRebalancer
│   ├── components/      # ViewComponents (DebtCard, SIPCalculator, etc.)
│   └── views/           # ERB templates
├── src/                 # Vite React landing page
├── config/              # Rails configuration
├── db/migrate/          # Database migrations
├── docs/                # Documentation + roadmap
├── installer/           # Curl install script
├── tests/               # E2E tests for full stack
├── compose.yml          # Docker Compose (builds locally)
├── Dockerfile           # Container definition
└── PROGRESS.md          # Feature progress tracking
```

## Development Workflow

### Local Development
```bash
# Start the app
bin/dev

# Or with Docker
docker compose up --build
```

### Testing
```bash
# Rails tests
bundle exec rspec

# Frontend tests (Vitest)
npm run test

# E2E tests
npm run test:e2e
```

## Current Status

- [x] v0.1 — Installer + Docker + AI Connector
- [x] v0.2 — Debt Payoff Module (Avalanche/Snowball)
- [x] v0.3 — Dividend SIP Planner
- [x] v0.4 — Portfolio Rebalancing
- [ ] v0.5 — Wealth Tracker (multi-asset portfolio, net worth)
- [ ] v1.0 — Security hardening + docs + CI/CD
