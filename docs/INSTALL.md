# Kubera Installation & Testing Guide

## Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/installer/install.sh | bash
```

This single command:
1. Asks install directory (default: `~/.kubera`)
2. Asks OpenRouter API key (for AI features)
3. Clones Kubera repo
4. Sets up database
5. Creates `.env` with your API key

---

## Manual Install (Step-by-Step)

### Prerequisites
- Docker & Docker Compose
- Git

### Steps

1. **Clone Kubera**
   ```bash
   git clone https://github.com/sdachary/kubera.git
   cd kubera
   ```

2. **Setup Environment**
   ```bash
   cp .env.example .env
   # Edit .env — set SECRET_KEY_BASE and POSTGRES_PASSWORD
   ```

3. **Start with Docker**
   ```bash
   docker compose up -d
   ```

4. **Run Migrations**
   ```bash
   docker compose exec web bin/rails db:migrate
   ```

5. **Access Kubera**
   Open http://localhost:3000 (or http://localhost:3002 if using Docker)

---

## Testing Features

### v0.1 — Installer + Docker Setup ✅
- Check Docker setup: `docker compose ps`
- Test AI connector: Go to Settings → AI → Test connection

### v0.2 — Debt Payoff Module ✅
```bash
# Avalanche method
curl http://localhost:3000/api/v1/debt_payoff/avalanche

# Snowball method
curl http://localhost:3000/api/v1/debt_payoff/snowball

# What-if simulation
curl "http://localhost:3000/api/v1/debt_payoff/simulate?debt_id=1&extra_monthly_payment=500"
```

### v0.3 — Dividend SIP Planner ✅
```bash
curl "http://localhost:3000/api/v1/dividend_sip/suggest?monthly_investment=10000&target_income=50000"
```

### v0.4 — Portfolio Rebalancing ✅
```bash
curl http://localhost:3000/api/v1/portfolio/rebalance
```

### v0.5 — Recurring Expense Tracker ✅
```bash
curl http://localhost:3000/api/v1/recurring_expenses
```

### v1.0 — Full Debt → Wealth Journey ✅
```bash
curl http://localhost:3000/api/v1/journey/progress
curl http://localhost:3000/api/v1/journey/projection
```

---

## Troubleshooting

### Logs
```bash
docker compose logs -f web
```

### Common Issues
1. **Port 3000 in use:**
   ```bash
   PORT=3001 docker compose up -d
   ```

2. **Database connection error:**
   ```bash
   docker compose restart db
   ```

3. **Migrations pending:**
   ```bash
   docker compose exec web bin/rails db:migrate
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
