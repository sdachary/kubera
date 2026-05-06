# Kubera User Flow — After Curl Install

## What Happens When You Run:
```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/installer/install.sh | bash -s ~/kubera
```

---

## 🔍 Step-by-Step Flow Summary

### 1️⃣ Installation Completes
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
- **Sure fork** inside: `~/kubera/sure/`
- **Dependencies** installed: Ruby gems + Node packages
- **Database** setup: PostgreSQL + migrations
- **.env.local** created in `sure/`

---

### 2️⃣ What Happens After Install (Zero-Config)
After the curl command completes, the terminal shows:
```
Installation complete!
Location: ~/kubera
To start:
  cd ~/kubera/sure && bin/dev
Visit: http://kubera.test (or http://localhost:3000)
```

**User just opens the URL:**
- No manual setup needed
- No database config needed
- No API key setup needed (optional for AI features)

**What starts automatically:**
- Rails server (dynamic port)
- Vite dev server (frontend)
- Database already setup by installer
```

---

### 3️⃣ First Visit — Zero State
**URL:** http://kubera.test (or http://localhost:3000)

**What you'll see:**
```
┌─────────────────────────────────────────┐
│          KUBERA                     │
│    Zero is better than negative.       │
├─────────────────────────────────────────┤
│ 🏠 Welcome to Kubera              │
│                                 │
│  [Crate Account] [Login]          │
└─────────────────────────────────────────┘
```

---

### 4️⃣ Onboarding Flow

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
  - Balance: ₹5,00,000
  - Interest rate: 12%
  - EMI: ₹15,000
  - Due date: 5th of every month
- **AI analyzes:** "At this rate, debt-free in 42 months"

#### Step 4: See Your Journey
**Dashboard shows:**
```
┌─────────────────────────────────────────┐
│  DEBT → ZERO → WEALTH          │
├─────────────────────────────────────────┤
│                                 │
│  🔄 Debt Progress: 0%             │
│     ₹5,00,000 remaining         │
│     📅 Debt-free: May 2029      │
│                                 │
│  📈 SIP Planner:               │
│     Target: ₹50,000/month         │
│     AI suggests: INFY, TCS, HDFC  │
│                                 │
│  🔄 Portfolio:                 │
│     Need ₹10L+ to start           │
└─────────────────────────────────────────┘
```

---

### 5️⃣ Explore Features (By Phase)

#### 🔄 v0.2 — Debt Payoff (Active)
**URL:** http://kubera.test/debts

**What you'll see:**
- **Debt List** (DebtList component)
- **Debt Card** per loan:
  ```
  Home Loan
  ₹5,00,000 @ 12% | EMI: ₹15,000
  [████████░░░░] 30% paid
  Debt-free: May 2029
  ```
- **Payoff Simulator** (PayoffSimulator):
  ```
  "What if I pay ₹20,000/month?"
  → Debt-free: Feb 2028 (14 months earlier!)
  ```

**API Test:**
```bash
curl http://kubera.test/api/v1/debt_payoff/avalanche
# Returns: avalanche method payoff schedule
```

---

#### 📈 v0.3 — Dividend SIP (Active)
**URL:** http://kubera.test/sip

**What you'll see:**
- **SIP Calculator**:
  ```
  Monthly investment: ₹50,000
  Target income: ₹50,000/month
  AI suggests: INFY (2.5%), TCS (1.8%), HDFC (1.2%)
  Projected: ₹51,200/month in 42 months
  ```
- **Stock Suggestion UI** (StockSuggestion component)

**API Test:**
```bash
curl "http://kubera.test/api/v1/dividend_sip/suggest?monthly_investment=50000&target_income=50000"
```

---

#### 🔄 v0.4 — Portfolio Rebalancing (Active)
**URL:** http://kubera.test/portfolio

**What you'll see:**
- **Portfolio Dashboard**:
  ```
  Current Allocation:
  Large Cap: 60% (target: 50%) → ⚠️ Overweight
  Mid Cap: 20% (target: 30%) → ⬇️ Underweight
  Debt: 20% (target: 0%) → ✅ On track
  
  [Rebalance Now] → AI suggests: Sell ₹2L large cap, buy ₹2L mid cap
  ```

---

#### 🔄 v0.5 — Recurring Expenses (Active)
**URL:** http://kubera.test/expenses

**What you'll see:**
- **Recurring Calendar**:
  ```
  May 2026:
  5th: Home Loan EMI ₹15,000
  10th: Electricity ₹3,000
  15th: SIP ₹50,000
  ```
- **Overdue Alerts**: "⚠️ Home Loan EMI overdue by 2 days!"

---

#### 🔄 v1.0 — Full Journey (Active)
**URL:** http://kubera.test/dashboard

**What you'll see:**
- **Unified Dashboard** (UnifiedDashboard component):
  ```
  🔄 Debt Progress: 0% → 100%
  📈 SIP Progress: ₹2L → ₹50L target
  🔄 Portfolio: Balanced ✅
  📅 Zero Day: May 2029 ← Milestone tracker
  
  [Export CSV] [Export PDF] ← Exportable financial plan
  ```

**API Test:**
```bash
curl http://kubera.test/api/v1/journey/dashboard
# Returns: debt + SIP + portfolio + zero day status
```

---

### 6️⃣ AI Features (Requires OpenRouter Key)

#### AI Chat (v2.0 — Planned)
```bash
# Settings → AI → Add OpenRouter API Key
# Then: "Ask AI" button appears everywhere
```

**Example queries:**
- "How can I pay off my home loan faster?"
- "Which stocks give best dividend yield?"
- "Is my portfolio balanced correctly?"

---

### 7️⃣ Settings & Management

**URL:** http://kubera.test/settings

**What you can do:**
- 🔑 **Profile:** Change email, password
- 🤖 **AI:** Add OpenRouter API key
- 🏦 **Connections:** Manage bank connections
- 🌐 **URL:** Change slug (kubera.test → myfinance.test)
- 📂 **Export:** Download CSV/PDF financial plan
- 🚪 **Stop:** `Ctrl+C` in terminal (bin/dev)

---

## 📂 File Structure After Install

```
~/kubera/                    # Main repo
├── installer/              # Install script (curl source)
├── docs/                  # Documentation
├── sure/                  # Rails app (Sure fork)
│   ├── app/
│   │   ├── controllers/   # API: /api/v1/debt_payoff, etc.
│   │   ├── models/        # Loan, RecurringExpense, etc.
│   │   ├── services/      # DebtPayoffCalculator, etc.
│   │   └── components/   # DebtCard, SIPCalculator, etc.
│   ├── config/
│   └── db/migrate/       # All migrations (v0.1 → v1.0)
├── .env.local             # Your API keys (gitignored)
└── README.md
```

---

## 🧪 Quick Tests After Install

### Test Debt Module
```bash
curl http://kubera.test/api/v1/debt_payoff/avalanche
```

### Test Dividend SIP
```bash
curl http://kubera.test/api/v1/dividend_sip/suggest
```

### Test Journey Dashboard
```bash
curl http://kubera.test/api/v1/journey/dashboard
```

### Test Export
```bash
curl http://kubera.test/api/v1/export/csv > my-financial-plan.csv
```

---

## 🔧 Troubleshooting

### Port Conflict?
```bash
# Check what's running
lsof -i :3000
# Kill if needed
kill -9 <PID>
```

### Database Issue?
```bash
cd ~/kubera/sure
bin/rails db:reset
bin/setup
```

### Dependencies Missing?
```bash
cd ~/kubera/sure
bundle install
npm install
```

---

## ✅ Success Checklist

After install, you should have:
- [ ] `~/kubera/` directory created
- [ ] `~/kubera/sure/` running on http://kubera.test
- [ ] Can create account + login
- [ ] Can add debt + see payoff projection
- [ ] Can use SIP planner (AI suggestions)
- [ ] Can see unified dashboard (Zero → Wealth)

---

**Next Step:** Open http://kubera.test and start your journey from debt to wealth! 🚀
