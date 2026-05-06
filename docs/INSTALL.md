# Kubera Installation & Testing Guide

## Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/kubera.rb | ruby
```

This single command:
1. Asks install directory (default: `~/.kubera`)
2. Asks OpenRouter API key (for AI features)
3. Clones Kubera repo into `kubera/` subdirectory
4. Applies all Kubera features (v0.1 → v1.0)
5. Creates `.env.local` with your API key

---

## Manual Install (Step-by-Step)

### Prerequisites
- Ruby 3.0+ (for Rails)
- Node.js 18+ (for frontend)
- PostgreSQL
- Git

### Steps

1. **Clone Kubera**
   ```bash
   git clone https://github.com/sdachary/kubera.git ~/.kubera
   cd ~/.kubera
   ```

2. **Clone Kubera into `kubera/`**
   ```bash
   git clone https://github.com/we-promise/kubera.git kubera
   ```

3. **Setup Environment**
   ```bash
   cd kubera
   cp .env.local.example .env.local
   # Edit .env.local and add:
   # OPENROUTER_API_KEY=your_key_here
   # DATABASE_URL=postgresql://localhost/kubera_development
   ```

4. **Install Dependencies**
   ```bash
   cd ~/.kubera/kubera
   bundle install
   npm install
   ```

5. **Setup Database**
   ```bash
   bin/setup
   ```

6. **Run Migrations**
   ```bash
   bin/rails db:migrate
   ```

7. **Start Server**
   ```bash
   bin/dev
   ```

8. **Access Kubera**
   Open http://localhost:3000 in your browser

---

## Testing Features

### v0.1 — Installer + Docker Setup ✅
- Verify installer works: `curl -fsSL URL | ruby`
- Check Docker setup: `docker-compose up`
- Test AI connector: Go to Settings → AI → Test connection

### v0.2 — Debt Payoff Module ✅
**API Endpoints:**
```bash
# Avalanche method
curl http://localhost:3000/api/v1/debt_payoff/avalanche

# Snowball method
curl http://localhost:3000/api/v1/debt_payoff/snowball

# Debt-free date projection
curl http://localhost:3000/api/v1/debt_payoff/payoff_date

# EMI calendar
curl http://localhost:3000/api/v1/debt_payoff/calendar?month=5&year=2026

# What-if simulation
curl "http://localhost:3000/api/v1/debt_payoff/simulate?debt_id=1&extra_monthly_payment=500"
```

**UI Components:**
- Go to http://localhost:3000/debts
- See DebtList, DebtCard, PayoffSimulator components

### v0.3 — Dividend SIP Planner ✅
```bash
# Get stock suggestions
curl "http://localhost:3000/api/v1/dividend_sip/suggest?monthly_investment=10000&target_income=50000"
```

**UI Components:**
- Go to http://localhost:3000/sip
- Use SIPCalculator and StockSuggestion components

### v0.4 — Portfolio Rebalancing ✅
```bash
# Get rebalancing suggestions
curl http://localhost:3000/api/v1/portfolio/rebalance
```

**UI Components:**
- Go to http://localhost:3000/portfolio
- See PortfolioDashboard component

### v0.5 — Recurring Expense Tracker ✅
```bash
# List recurring expenses
curl http://localhost:3000/api/v1/recurring_expenses

# Create recurring expense
curl -X POST http://localhost:3000/api/v1/recurring_expenses \
  -d "recurring_expense[amount]=5000&recurring_expense[frequency]=monthly&recurring_expense[next_due_date]=2026-06-01&recurring_expense[category]=emi"

# Check overdue
curl -X POST http://localhost:3000/api/v1/recurring_expenses/notify
```

**UI Components:**
- Go to http://localhost:3000/expenses
- See RecurringCalendar and RecurringList

### v1.0 — Full Debt → Wealth Journey ✅
```bash
# Unified dashboard
curl http://localhost:3000/api/v1/journey/dashboard

# Net worth chart
curl http://localhost:3000/api/v1/journey/net_worth_chart

# Export to CSV
curl http://localhost:3000/api/v1/export/csv > financial-plan.csv

# Export to PDF
curl http://localhost:3000/api/v1/export/pdf > financial-plan.pdf
```

**UI Components:**
- Go to http://localhost:3000/dashboard
- See UnifiedDashboard with progress tracking

---

## Troubleshooting

### Logs
```bash
# Rails logs
tail -f ~/.kubera/kubera/log/development.log

# Frontend (Vite)
tail -f ~/.kubera/kubera/log/vite.log
```

### Common Issues
1. **Port 3000 in use:**
   ```bash
   lsof -i :3000
   kill -9 <PID>
   ```

2. **Database connection error:**
   ```bash
   sudo -u postgres createuser -s $(whoami)
   createdb kubera_development
   ```

3. **Missing dependencies:**
   ```bash
   cd ~/.kubera/kubera
   bundle install
   npm install
   ```

4. **Migrations pending:**
   ```bash
   bin/rails db:migrate
   ```

---

## Verification Checklist

- [ ] Installer runs without errors
- [ ] Homepage loads at http://localhost:3000
- [ ] Debt payoff calculator works (API + UI)
- [ ] Dividend SIP planner suggests stocks
- [ ] Portfolio rebalancing shows suggestions
- [ ] Recurring expenses appear in calendar
- [ ] Journey dashboard shows progress
- [ ] Export (CSV/PDF) works
- [ ] AI chat responds (if OpenRouter key provided)

---

**Need help?** Open an issue: https://github.com/sdachary/kubera/issues
