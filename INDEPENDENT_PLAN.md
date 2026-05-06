# Kubera - Independent Application Plan

## Goal: Break free from Sure dependency, build standalone app.

### Current State:
- Forked Sure (sure/) with added features v0.2-v1.0
- Dependency on Sure's architecture, models, migrations
- Hard to merge upstream updates`

### Target State:
- **All features from v0.2-v1.0 rebuilt natively**
- **No references to Sure/Maybe**
- **Single Rails app** (no React/Vite split-brain)
- **All data stays local** (no external API calls except optional AI)

---

## Architecture: Single Rails App`

```
kubera/
├── app/
│   ├── models/        # Debt, SIP, Portfolio, RecurringExpense (native)
│   ├── controllers/   # All v0.2-v1.0 endpoints
│   ├── services/      # DebtPayoff, DividendScreener, etc.
│   ├── views/         # ERB templates (Tailwind CSS)
│   └── assets/       # JS/CSS (no React/Vite)
├── config/
├── db/
│   └── migrate/      # Clean migrations (no Sure history)
├── docs/
└── installer/       # Zero-config curl installer`
```

---

## Phase 1: Core Models (Claude Code via mcp-hub)

**Task:** Create native Kubera models (no Sure inheritance)

1. **Debt** (replaces Loan)
   - Fields: amount, interest_rate, emi_amount, due_date, status`
   - Methods: months_remaining, debt_free_date, progress_percentage`

2. **Investment** (for SIP)
   - Fields: symbol, name, dividend_yield, risk_level`
   - Methods: calculate_sip, project_income`

3. **Portfolio** (for rebalancing)
   - Fields: asset_type, allocation_percent, target_percent`
   - Methods: rebalance_suggestions`

4. **RecurringExpense**
   - Fields: amount, frequency, next_due_date, category`
   - Methods: overdue?, generate_upcoming`

**Agent:** Claude Code (frontend agent via mcp-hub)

---

## Phase 2: Services & API (Gemini CLI via mcp-hub)

**Task:** Port all v0.2-v1.0 services natively`

1. **DebtPayoffCalculator** (from v0.2)
   - Avalanche method`
   - Snowball method`
   - Payoff simulation`

2. **DividendScreener** (from v0.3)
   - Stock suggestions (NSE/BSE)`
   - SIP calculator`

3. **PortfolioRebalancer** (from v0.4)
   - Modern Portfolio Theory`
   - Asset allocation`

4. **WealthJourneyTracker** (from v1.0)
   - Unified dashboard data`
   - Net worth trajectory`

5. **API Endpoints:**
   - `/api/v1/debt_payoff` (avalanche, snowball, simulate)`
   - `/api/v1/dividend_sip` (suggest)`
   - `/api/v1/portfolio` (rebalance)`
   - `/api/v1/journey` (dashboard)`
   - `/api/v1/recurring_expenses` (CRUD)`

**Agent:** Gemini CLI (typescript agent via mcp-hub)

---

## Phase 3: Controllers & UI (NVIDIA via mcp-hub)

**Task:** Rebuild all controllers and views natively`

1. **API Controllers:**
   - `Api::V1::DebtPayoffController`
   - `Api::V1::DividendSipController`
   - `Api::V1::PortfolioController`
   - `Api::V1::JourneyController`
   - `Api::V1::RecurringExpensesController`

2. **Views (ERB + Tailwind CSS):**
   - Debt List, Debt Card, Payoff Simulator`
   - SIP Calculator, Stock Suggestion`
   - Portfolio Dashboard`
   - Unified Journey Dashboard`
   - Recurring Calendar`

**Agent:** NVIDIA (github agent via mcp-hub)

---

## Phase 4: Installer & Zero-Config (Claude Code)

**Task:** Rebuild installer for standalone app`

1. **installer/install.sh:**
   - curl → clones kubera.git (no sure/)`
   - Auto bundle install && npm install`
   - Auto bin/setup`
   - Starts server automatically`
   - Shows URL: http://kubera.test`

2. **No external dependencies:**
   - No Sure fork needed`
   - All features native`
   - Data stays local (except optional AI)`

**Agent:** Claude Code (frontend agent)

---

## Phase 5: Security & Audit (Gemini CLI)

**Task:** Ensure local-only data`

1. **Remove all external API calls** (except optional AI):
   - No Plaid, SimpleFIN, Lunchflow`
   - Local CSV import only`

2. **Secure API key storage:**
   - Use Argon2 hashing (not deterministic encryption)`
   - Remove hardcoded DEMO_MONITORING_KEY`

3. **Audit .env:**
   - Only DATABASE_URL, OPENROUTER_API_KEY (optional)`
   - No external service credentials`

**Agent:** Gemini CLI (typescript agent)

---

## Phase 6: Testing & Polish (All Agents)

**Task:** Test all v0.2-v1.0 features natively`

1. **Test all endpoints:**
   - Debt payoff (Avalanche/Snowball)`
   - Dividend SIP planner`)
   - Portfolio rebalancing`)
   - Unified journey dashboard`)
   - Recurring expenses`)

2. **Update docs:**
   - README: "Standalone app, no Sure dependency"`
   - USER_FLOW: Simplified (no bank connections)`
   - INSTALL: Zero-config curl experience`)

---

## Execution Strategy (via mcp-hub)`

**Distribute token usage across agents:**

1. **Claude Code** (30% tokens):
   - Phase 1 (Models)`
   - Phase 4 (Installer)`

2. **Gemini CLI** (40% tokens):
   - Phase 2 (Services & API)`
   - Phase 5 (Security & Audit)`

3. **NVIDIA** (30% tokens):
   - Phase 3 (Controllers & UI)`

---

## Success Criteria`

- [ ] `grep -r "sure\|maybe" . --include="*.rb" --include="*.js" | grep -v ".git" | wc -l` returns 0`
- [ ] `curl -fsSL URL | bash -s ~/kubera` works`
- [ ] http://kubera.test opens dashboard`
- [ ] All v0.2-v1.0 features work natively`
- [ ] No external API calls (except optional AI)`
- [ ] Token usage distributed (no single agent hit limit)`

---

## Next Step`

I'll spawn all 3 agents via mcp-hub now.
