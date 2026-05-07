# Kubera Roadmap

Full plan for the debt → zero → wealth journey.

---

## ✅ v0.1 — Installer + Docker Setup + AI Connector (Completed)

- [x] One-line install (`installer/install.sh`)
- [x] Docker Compose setup with standalone Rails app
- [x] AI connector (OpenRouter, Ollama, Anthropic, OpenAI)
- [x] Environment config with secure random keys

---

## ✅ v0.2 — Debt Payoff Module (Completed)

- [x] Debt onboarding wizard
- [x] Avalanche method (highest interest first)
- [x] Snowball method (smallest balance first)
- [x] Debt-free date projection
- [x] Payoff simulation (what-if scenarios)
- [x] Debt UI components (DebtList, DebtCard, PayoffSimulator)
- [x] API endpoints: `/api/v1/debt_payoff`

---

## ✅ v0.3 — Dividend SIP Planner (Completed)

- [x] Monthly contribution target setup
- [x] AI suggestion engine (2-3 stocks based on income goal)
- [x] SIP calculator with timeline projection
- [x] API endpoints: `/api/v1/dividend_sip`

---

## ✅ v0.4 — Portfolio Rebalancing (Completed)

- [x] Asset allocation optimization (Modern Portfolio Theory)
- [x] Risk-adjusted returns calculation
- [x] Rebalancing suggestions (buy/sell/hold)
- [x] API endpoints: `/api/v1/portfolio/rebalance`

---

## ✅ v0.5 — Recurring Expense Tracker (Completed)

- [x] Recurring expense management (EMI, rent, subscriptions)
- [x] Calendar view with due dates
- [x] Overdue alerts
- [x] Auto-categorization
- [x] API endpoints: `/api/v1/recurring_expenses`

---

## ✅ v1.0 — Full Debt → Wealth Journey (Completed)

- [x] Unified dashboard: debt + SIP + portfolio + net worth
- [x] "Zero Day" milestone tracker
- [x] Passive income projection vs. target
- [x] Net worth trajectory chart (debt → zero → wealth)
- [x] Wealth growth projection (30-year model)
- [x] Exportable financial plan (PDF/CSV)
- [x] Security hardening (Argon2 API key hashing, rate limiting)
- [x] Standalone architecture (no external fork dependencies)
- [x] API endpoints: `/api/v1/journey`, `/api/v1/net_worth_snapshots`

---

## 🔄 v0.5b — Wealth Tracker (In Progress)

- [ ] Multi-asset portfolio tracking (stocks, ETFs, mutual funds)
- [ ] Real-time net worth calculation with Yahoo Finance
- [ ] Wealth growth projections (5/10/20/30 year view)
- [ ] Net worth snapshot history with trend chart
- [ ] Integration with external market data APIs

---

## 🔄 v2.0 — AI Financial Advisor (Planned)

- [ ] AI chat for financial queries
- [ ] Spending pattern analysis
- [ ] Investment recommendations based on risk profile
- [ ] Tax optimization suggestions
- [ ] AI-generated financial health report

---

## 🔄 v3.0 — Multi-User & Collaboration (Planned)

- [ ] Multi-user support (family members)
- [ ] Shared budgets and goals
- [ ] Family financial dashboard
- [ ] Permission management (view/edit/admin)

---

*Last updated: 2026-05-08. See PROGRESS.md for task-level tracking.*
