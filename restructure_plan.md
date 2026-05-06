# Kubera Restructuring Plan — Independent App

## Goal: Make Kubera 100% independent (no Sure dependency)

### Current Problem:
- `sure/` is a full fork of Maybe/Sure (huge, 177+ migrations)
- User data could leak if we keep cloud dependencies
- Confusing architecture (Rails monolith + React landing page)

### Solution: Extract ONLY what we need, build independent app

---

## Step 1: Create Clean Rails App (Independent)

```bash
# AI Agent (Claude Code): Create fresh Rails 7.1 app
# - Minimal: API-only, PostgreSQL, Redis
# - Keep: v0.2-v1.0 features (Debt, SIP, Portfolio, Expenses)
# - Drop: All Sure/Maybe bloat (177 migrations → 5-10 focused ones)
```

**AI Task via mcp-hub:**
```
"Create independent Kubera Rails app at /tmp/kubera-clean.
Requirements:
1. Rails 7.1 + PostgreSQL + Redis (Sidekiq)
2. Only these models:
   - User (devise or rails7-auth)
   - Account (polymorphic: Loan, Investment, etc.)
   - Loan (emi_amount, due_date, debt_status, interest_rate)
   - RecurringExpense (amount, frequency, next_due_date)
   - PortfolioHolding (symbol, shares, avg_cost)
   - ApiKey (hashed, not encrypted)
3. Only v0.2-v1.0 API endpoints:
   - /api/v1/debt_payoff (avalanche, snowball, simulate)
   - /api/v1/dividend_sip (suggest)
   - /api/v1/portfolio (rebalance)
   - /api/v1/journey (dashboard)
   - /api/v1/recurring_expenses (CRUD)
4. Keep React frontend (Vite) but integrate via vite_ruby gem
5. Single install: curl → Rails serves everything"
```

---

## Step 2: Migrate Features (AI-Powered)

### Claude Code Task:
```
"Migrate these from sure/ to clean app:
1. DebtPayoffCalculator service (Avalanche/Snowball)
2. DividendScreener service (AI stock suggestions)
3. WealthJourneyTracker (unified dashboard)
4. PortfolioRebalancer (Modern Portfolio Theory)
5. ExportService (CSV/PDF)
6. All v0.2-v1.0 controllers (simplify, keep only our features)
```

### Gemini CLI Task:
```
"Migrate frontend components:
1. DebtList, DebtCard, PayoffSimulator (React + Tailwind)
2. SIPCalculator, StockSuggestion
3. PortfolioDashboard, RecurringCalendar
4. UnifiedDashboard (Journey: Debt → Zero → Wealth)
5. Use Tailwind CSS (not inline styles from design-system/colors.js)
6. Integrate with Rails via vite_ruby"
```

### NVIDIA Task:
```
"Setup infrastructure:
1. Dockerfile (multi-stage: build React + Rails)
2. docker-compose.yml (Rails + Postgres + Redis)
3. Installer script: curl → docker-compose up (zero-config)
4. Ensure NO data leaves user's machine (local-only mode)
5. AI features optional (OpenRouter key in .env.local)"
```

---

## Step 3: Local-Only Privacy (No Data Leak)

### Security Checklist (AI Agent):
```
"Ensure Kubera is 100% local:
1. NO external API calls except user-provided OpenRouter key
2. NSE/BSE data: bundle with app (no live API)
3. Export ONLY local (CSV/PDF to user's Downloads)
4. Remove all Sure/Maybe telemetry/tracking
5. Add privacy notice: 'Your data never leaves this machine'"
```

---

## Step 4: Single Curl Install (Zero-Config)

### Final Installer (AI Agent):
```bash
#!/bin/bash
# Kubera — Zero-Config Local Install
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash

# What it does:
1. Checks Docker (installs if missing)
2. Downloads docker-compose.yml
3. Runs: docker-compose up -d
4. Shows: "Visit http://localhost:3000"
5. NO manual setup, NO database config, NO Ruby/Node install
```

---

## Step 5: Financial Guide (What User Sees)

### After curl → opens URL:
```
1. Welcome to Kubera
   "Your data stays on this machine 🔒"

2. Add Debt (Home Loan ₹50L, 12%)
   AI: "Debt-free by May 2029 (Avalanche method)"

3. Setup SIP (₹50k/month → ₹50k passive income)
   AI: "INFY (2.5%), TCS (1.8%), HDFC (1.2%)"

4. Track Journey (Debt → Zero → Wealth)
   Dashboard: Progress + Projections + Alerts

5. Export (optional)
   "Download your financial plan (CSV/PDF)"
```

---

## Step 6: Distribute Work via mcp-hub

### Spawn Agents Now:
```bash
# Claude Code: Create clean Rails app
curl -X POST http://localhost:3000/api/agent/spawn \
  -H "X-API-Key: mcp-hub-secret-key-2026" \
  -d '{"agentId":"frontend","prompt":"Create independent Kubera Rails 7.1 app...","workingDir":"/tmp/kubera-clean"}'

# Gemini CLI: Migrate frontend
curl -X POST http://localhost:3000/api/agent/spawn \
  -H "X-API-Key: mcp-hub-secret-key-2026" \
  -d '{"agentId":"typescript","prompt":"Migrate React components to Tailwind...","workingDir":"/tmp/kubera-clean"}'

# NVIDIA: Setup Docker + Privacy
curl -X POST http://localhost:3000/api/agent/spawn \
  -H "X-API-Key: mcp-hub-secret-key-2026" \
  -d '{"agentId":"github","prompt":"Setup Docker + ensure local-only privacy...","workingDir":"/tmp/kubera-clean"}'
```

---

## Final Result:

### User Experience:
```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash
# Opens http://localhost:3000
# "Your data never leaves this machine 🔒"
# Adds debt → sees AI plan → tracks journey → exports locally
```

### Architecture:
```
kubera/                    # Single independent repo
├── app/                  # Clean Rails 7.1 app
│   ├── models/        # Only: User, Account, Loan, etc.
│   ├── controllers/   # Only v0.2-v1.0 endpoints
│   ├── services/     # DebtPayoff, DividendScreener, etc.
│   └── frontend/      # React + Vite Ruby
├── docker-compose.yml      # Zero-config install
├── installer/             # Single curl script
└── docs/                 # Roadmap + USER_FLOW
```

### No Dependencies:
- ❌ No Sure/Maybe fork
- ❌ No 177+ migrations
- ❌ No external data leaks
- ✅ Independent, privacy-first, zero-config
