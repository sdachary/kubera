# Kubera User Flow — After Curl Install

## What Happens When You Run:
```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/installer/install.sh | bash -s ~/kubera
```

---

## Step-by-Step Flow Summary

### 1. Installation Completes
```
Kubera Installer v0.3
Installing to: /home/deepak/kubera
Cloning Kubera repository...
Installing dependencies...
Setting up database...
Installation complete!
```

**What's installed:**
- **Kubera repo** cloned to `~/kubera/`
- **Dependencies** installed: Ruby gems + Node packages
- **Database** setup: PostgreSQL + migrations
- **.env** created at root

---

### 2. What Happens After Install (Zero-Config)
After the curl command completes, the terminal shows:
```
Installation complete!
Location: ~/kubera
To start:
  cd ~/kubera && bin/dev
Visit: http://localhost:3000
```

**User just opens the URL:**
- No manual setup needed
- No database config needed
- No API key setup needed (optional for AI features)

**What starts automatically:**
- Rails server (dynamic port)
- Database already setup by installer

---

### 3. First Visit — Zero State
**URL:** http://localhost:3000

**What you'll see:**
```
  Welcome to Kubera
  Zero is better than negative.

  [Create Account] [Login]
```

---

### 4. Onboarding Flow

#### Step 1: Create Account
- Enter email + password
- Lands on **Dashboard** (Zero State)

#### Step 2: Connect Bank (Optional)
- Go to **Settings → Connections**
- Connect via:
  - Plaid (US/UK)
  - SimpleFIN (Self-hosted)
  - Manual CSV import

#### Step 3: Add Debt (Core Feature)
- Go to **Debts** tab
- Click **Add Loan**
- Fill in:
  - Loan type (Home, Car, Credit Card, etc.)
  - Balance: Rs 5,00,000
  - Interest rate: 12%
  - EMI: Rs 15,000
  - Due date: 5th of every month
- **AI analyzes:** "At this rate, debt-free in 42 months"

#### Step 4: See Your Journey
**Dashboard shows:**
```
  DEBT -> ZERO -> WEALTH

  Debt Progress: 0%
     Rs 5,00,000 remaining
     Debt-free: May 2029

  SIP Planner:
     Target: Rs 50,000/month
     AI suggests: INFY, TCS, HDFC

  Portfolio:
     Need Rs 10L+ to start
```

---

### 5. Explore Features (By Phase)

#### v0.2 -- Debt Payoff (Active)
**URL:** http://localhost:3000/debts

**What you'll see:**
- **Debt List** (DebtList component)
- **Debt Card** per loan
- **Payoff Simulator**: "What if I pay Rs 20,000/month?"

**API Test:**
```bash
curl http://localhost:3000/api/v1/debt_payoff/avalanche
```

---

#### v0.3 -- Dividend SIP (Active)
**URL:** http://localhost:3000/sip

**What you'll see:**
- **SIP Calculator**: Project income based on monthly investment
- **Stock Suggestion UI**

**API Test:**
```bash
curl "http://localhost:3000/api/v1/dividend_sip/suggest?monthly_investment=50000&target_income=50000"
```

---

#### v0.4 -- Portfolio Rebalancing (Active)
**URL:** http://localhost:3000/portfolio

**What you'll see:**
- **Portfolio Dashboard**: Current allocation vs target
- **Rebalancing suggestions**

---

#### v0.5 -- Recurring Expenses (Active)
**URL:** http://localhost:3000/expenses

**What you'll see:**
- **Recurring Calendar**: EMI, subscriptions, utilities
- **Overdue Alerts**

---

#### v1.0 -- Full Journey (Active)
**URL:** http://localhost:3000/dashboard

**What you'll see:**
- **Unified Dashboard**: Debt + SIP + Portfolio + Net Worth
- **Zero Day milestone tracker**
- **Wealth growth projection** (30-year model)
- **Export** CSV/PDF

**API Test:**
```bash
curl http://localhost:3000/api/v1/journey/progress
curl http://localhost:3000/api/v1/journey/projection
```

---

### 6. AI Features (Requires OpenRouter Key)

#### AI Chat (v2.0 -- Planned)
```bash
# Settings -> AI -> Add OpenRouter API Key
```

**Example queries:**
- "How can I pay off my home loan faster?"
- "Which stocks give best dividend yield?"
- "Is my portfolio balanced correctly?"

---

### 7. Settings & Management

**URL:** http://localhost:3000/settings

**What you can do:**
- **Profile:** Change email, password
- **AI:** Add OpenRouter API key
- **Connections:** Manage bank connections
- **Export:** Download CSV/PDF financial plan
- **Stop:** `Ctrl+C` in terminal (bin/dev)

---

## File Structure After Install

```
~/kubera/                    # Main repo
├── installer/              # Install script
├── docs/                  # Documentation
├── app/                   # Rails app
│   ├── controllers/      # API endpoints
│   ├── models/           # Data models
│   ├── services/         # Business logic
│   └── components/      # UI components
├── config/
├── db/migrate/           # Database migrations
├── .env                  # Your configuration
└── README.md
```

---

## Success Checklist

After install, you should have:
- [ ] `~/kubera/` directory created
- [ ] App running on http://localhost:3000
- [ ] Can create account + login
- [ ] Can add debt + see payoff projection
- [ ] Can use SIP planner (AI suggestions)
- [ ] Can see unified dashboard (Zero -> Wealth)

---

**Next Step:** Open http://localhost:3000 and start your journey from debt to wealth!
