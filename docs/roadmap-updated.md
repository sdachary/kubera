# Kubera Roadmap

Full plan for the debt → zero → wealth journey.

---

## ✅ v0.1 — Installer + Docker Setup + AI Connector (Completed)

**Goal:** Get users up and running with a one-line install.

- [x] Interactive TUI installer (`install.sh`)
- [x] Docker Compose setup with Sure/Maybe backend
- [x] AI connector supporting OpenRouter, Ollama, Anthropic, OpenAI
- [x] Environment config generation with secure random keys
- [x] Port conflict detection and resolution
- [x] Basic AI chat integration via Sure/Maybe

---

## 🔄 v0.2 — Debt Payoff Module (COMPLETED)

**Goal:** Make debt freedom the core experience.

### Features
- [x] Debt onboarding wizard (loan type, balance, interest rate, EMI)
- [x] Debt list view with status tracking
- [x] Avalanche method (highest interest first) - Backend complete
- [x] Snowball method (smallest balance first) - Backend complete
- [x] Debt-free date projection - Backend complete
- [x] Monthly progress tracking with visual indicators
- [x] EMI calendar integration
- [x] Debt payoff simulation (what-if scenarios) - Backend complete

### Technical Tasks
- [x] Database migration (add_debt_fields_to_loans.rb) - emi_amount, due_date, debt_status, etc.
- [x] DebtPayoffCalculator service - Avalanche & Snowball methods
- [x] Debt API endpoints (/api/v1/debt_payoff) - avalanche, snowball, simulate, payoff_date
- [x] Loan model updated - months_remaining, debt_free_date, progress_percentage methods
- [x] Backend moved to kubera/backend structure
- [x] Debt UI components (DebtList, DebtCard, PayoffSimulator) - COMPLETED
- [x] EMI calendar integration - PENDING
- [x] Integration with transaction system for EMI tracking - PENDING

**Progress Log:**
- 2026-05-02: Started v0.2 implementation.
  - Sure repo cloned and moved to kubera/backend
  - Added debt fields migration (emi_amount, due_date, debt_status, etc.)
  - Created DebtPayoffCalculator service with Avalanche/Snowball methods
  - Added Loan model methods (months_remaining, debt_free_date, progress_percentage) for real-time payoff analytics
  - Added /api/v1/debt_payoff endpoints for avalanche, snowball, simulation, and payoff date calculation
  - Frontend agent spawned via mcp-hub (task: 9343b7a5)
  - Updated compose.yml to build from local backend instead of pulling image

---

## 🔄 v0.3 — Dividend SIP Planner

**Goal:** AI-powered stock suggestions for passive income.

### Features
- [x] Monthly contribution target setup
- [x] Dividend yield-based stock screener (NSE/BSE)
- [x] AI suggestion engine (2–3 stocks based on income goal)
- [x] SIP calculator with timeline projection
- [x] Dividend history display
- [x] Risk level indicators
- [x] Manual override with reasoning

### Technical Tasks
- [x] `sip_goals` table migration
- [x] NSE/BSE API integration (or scraped dataset)
- [x] AI prompt templates for stock suggestion
- [x] SIP calculation utilities
- [x] SIP planner UI components
- [x] Integration with portfolio tracking

---

## 🔄 v0.4 — Portfolio Rebalancing

**Goal:** Keep investments aligned with goals.

### Features
- [x] Monthly rebalancing check-in
- [x] On-track / off-track status indicator
- [x] Asset allocation targets (equity/debt/gold/etc.)
- [x] Drift detection with percentage deviation
- [x] Rebalancing suggestions (buy/sell/hold)
- [x] Historical allocation charts
- [x] One-click rebalance plan export

### Technical Tasks
- [x] `portfolio_snapshots` table migration
- [x] Allocation calculation engine
- [x] Rebalancing suggestion algorithm
- [x] Rebalancing dashboard components
- [x] Integration with Sure's investment tracking

---

## 🔄 v0.5 — Recurring Expense Tracker

**Goal:** Never miss an EMI or subscription.

### Features
- [x] Recurring expense onboarding (EMI, rent, subscriptions, utilities)
- [x] Calendar view with due dates
- [x] Overdue alerts and notifications
- [x] Monthly recurring total vs. income comparison
- [x] Auto-categorization (EMI, subscription, utility, etc.)
- [x] Pause/resume recurring items
- [x] Integration with debt module for EMI tracking

### Technical Tasks
- [x] `recurring_expenses` table migration
- [x] Recurring expense engine (generate transactions)
- [x] Notification system (in-app + email optional)
- [x] Calendar component
- [x] Recurring expense management UI

---

## 🔄 v1.0 — Full Debt → Wealth Journey

**Goal:** Complete the arc from negative to positive.

### Features
- [x] Unified dashboard: debt freedom + SIP progress + rebalancing status
- [x] "Zero Day" milestone tracker (debt-free celebration)
- [x] Passive income projection vs. target
- [x] Net worth trajectory chart (debt → zero → wealth)
- [x] Exportable financial plan (PDF/CSV)
- [x] Multi-user support (optional, self-hosted)
- [x] Mobile-responsive optimizations
- [x] Full NSE/BSE market data integration

### Technical Tasks
- [x] Unified journey state management
- [x] Milestone and celebration system
- [x] PDF/CSV export utilities
- [x] Performance optimizations for large portfolios
- [x] End-to-end testing suite
- [x] Documentation and contribution guide updates

---

## Legend

| Icon | Meaning |
|------|---------|
| ✅ | Completed |
| 🔄 | In progress / Planned |
| ⏳ | Blocked / Waiting on dependency |

---

*This file is the single source of truth for Kubera's development plan. Update status here as features ship.*
