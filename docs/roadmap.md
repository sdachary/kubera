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

## 🔄 v0.2 — Debt Payoff Module

**Goal:** Make debt freedom the core experience.

### Features
- [ ] Debt onboarding wizard (loan type, balance, interest rate, EMI)
- [ ] Debt list view with status tracking
- [ ] Avalanche method (highest interest first)
- [ ] Snowball method (smallest balance first)
- [ ] Debt-free date projection
- [ ] Monthly progress tracking with visual indicators
- [ ] EMI calendar integration
- [ ] Debt payoff simulation (what-if scenarios)

### Technical Tasks
- [ ] `debts` table migration (amount, interest_rate, emi, due_date, type)
- [ ] Debt API endpoints (CRUD)
- [ ] Debt store/state management
- [ ] Debt components (DebtList, DebtCard, PayoffSimulator)
- [ ] Integration with Sure's transaction system for EMI tracking

---

## 🔄 v0.3 — Dividend SIP Planner

**Goal:** AI-powered stock suggestions for passive income.

### Features
- [ ] Monthly contribution target setup
- [ ] Dividend yield-based stock screener (NSE/BSE)
- [ ] AI suggestion engine (2–3 stocks based on income goal)
- [ ] SIP calculator with timeline projection
- [ ] Dividend history display
- [ ] Risk level indicators
- [ ] Manual override with reasoning

### Technical Tasks
- [ ] `sip_goals` table migration
- [ ] NSE/BSE API integration (or scraped dataset)
- [ ] AI prompt templates for stock suggestion
- [ ] SIP calculation utilities
- [ ] SIP planner UI components
- [ ] Integration with portfolio tracking

---

## 🔄 v0.4 — Portfolio Rebalancing

**Goal:** Keep investments aligned with goals.

### Features
- [ ] Monthly rebalancing check-in
- [ ] On-track / off-track status indicator
- [ ] Asset allocation targets (equity/debt/gold/etc.)
- [ ] Drift detection with percentage deviation
- [ ] Rebalancing suggestions (buy/sell/hold)
- [ ] Historical allocation charts
- [ ] One-click rebalance plan export

### Technical Tasks
- [ ] `portfolio_snapshots` table migration
- [ ] Allocation calculation engine
- [ ] Rebalancing suggestion algorithm
- [ ] Rebalancing dashboard components
- [ ] Integration with Sure's investment tracking

---

## 🔄 v0.5 — Recurring Expense Tracker

**Goal:** Never miss an EMI or subscription.

### Features
- [ ] Recurring expense onboarding (EMI, rent, subscriptions, utilities)
- [ ] Calendar view with due dates
- [ ] Overdue alerts and notifications
- [ ] Monthly recurring total vs. income comparison
- [ ] Auto-categorization (EMI, subscription, utility, etc.)
- [ ] Pause/resume recurring items
- [ ] Integration with debt module for EMI tracking

### Technical Tasks
- [ ] `recurring_expenses` table migration
- [ ] Recurring expense engine (generate transactions)
- [ ] Notification system (in-app + email optional)
- [ ] Calendar component
- [ ] Recurring expense management UI

---

## 🔄 v1.0 — Full Debt → Wealth Journey

**Goal:** Complete the arc from negative to positive.

### Features
- [ ] Unified dashboard: debt freedom + SIP progress + rebalancing status
- [ ] "Zero Day" milestone tracker (debt-free celebration)
- [ ] Passive income projection vs. target
- [ ] Net worth trajectory chart (debt → zero → wealth)
- [ ] Exportable financial plan (PDF/CSV)
- [ ] Multi-user support (optional, self-hosted)
- [ ] Mobile-responsive optimizations
- [ ] Full NSE/BSE market data integration

### Technical Tasks
- [ ] Unified journey state management
- [ ] Milestone and celebration system
- [ ] PDF/CSV export utilities
- [ ] Performance optimizations for large portfolios
- [ ] End-to-end testing suite
- [ ] Documentation and contribution guide updates

---

## Legend

| Icon | Meaning |
|------|---------|
| ✅ | Completed |
| 🔄 | In progress / Planned |
| ⏳ | Blocked / Waiting on dependency |

---

*This file is the single source of truth for Kubera's development plan. Update status here as features ship.*
