# Kubera Frontend — Design Reimagination Plan

## Design Foundation (from sri/Open Design)

| Token | Value | Role |
|-------|-------|------|
| `--paper` | `#f7f1de` | Page background |
| `--paper-warm` | `#efe7d2` | Card/secondary surfaces |
| `--ink` | `#15140f` | Body text |
| `--ink-mute` | `#5a5448` | Secondary text |
| `--coral` | `#ed6f5c` | Single accent (debt, warnings, CTAs) |
| `--emerald` | `#2d7d6a` | Positive/growth (investments, net worth up) |
| `--sans` | `Inter Tight` | Headings, navigation |
| `--body` | `Inter` | Body copy |
| `--serif` | `Playfair Display italic` | Emphasis, emotional moments |

**Why this works for fintech:** Warmth builds trust. Coral signals urgency (debt) without alarm. Emerald signals growth. The paper texture keeps it tactile, not cold.

**Design principles:**
- Every page is a tool, not a report — make the next action obvious
- Financial data is emotional — use color and space to reduce anxiety
- Mobile-first: one thumb, one column, scroll not tap
- Empty states are onboarding opportunities

---

## Feature Inventory (Backend API Available)

| # | Feature | API Status | Priority |
|---|---------|------------|----------|
| 1 | **Dashboard** (summary + projection) | ✅ Live | P0 |
| 2 | **Debts** (CRUD + payoff simulation) | ✅ Live | P0 |
| 3 | **Debt Payoffs** (simulate payoff plans) | ✅ Live | P0 |
| 4 | **Transactions** (CRUD + monthly totals) | ✅ Live | P0 |
| 5 | **Budgets** (CRUD + overview) | ✅ Live | P0 |
| 6 | **Budget Categories** (CRUD + seed defaults) | ✅ Live | P0 |
| 7 | **Portfolios** (CRUD + rebalance + research) | ✅ Live | P1 |
| 8 | **Journey** (show + progress + net worth) | ✅ Live | P1 |
| 9 | **Recurring Expenses** (CRUD + calendar) | ✅ Live | P1 |
| 10 | **Investments** (CRUD) | ✅ Live | P1 |
| 11 | **Dividend SIPs** (CRUD + suggestions) | ✅ Live | P1 |
| 12 | **Net Worth Snapshots** (list + detail) | ✅ Live | P1 |
| 13 | **Notifications** (list + mark read) | ✅ Live | P1 |
| 14 | **Reports** (annual, cash flow, anomalies, goals, net worth) | ✅ Live | P2 |
| 15 | **Exports** (CSV/JSON for debts, portfolios, transactions, net worth) | ✅ Live | P2 |
| 16 | **Households** (CRUD + members + invite + dashboard) | ✅ Live | P2 |
| 17 | **Conversations** (threads + messages) | ✅ Live | P2 |
| 18 | **DPDP** (consent, erasure, export, grievance) | ✅ Live | P3 |
| 19 | **Trip Mode** (trips, expenses, splits, settlements) | 🔴 Models exist, controllers deleted — needs API rewrite | P1 |

---

## Phase 1: Navigation & IA Foundation

**Goal:** Establish the navigation structure that all pages share.

### Pages grouped by user goal:

```
Dashboard ──────┬── Dashboard (home)
                ├── Projection (5-year view)
                └── Reports (annual, cash flow, anomalies)

Money In/Out ───┬── Transactions (log + categorize)
                ├── Budgets (set + track)
                ├── Budget Categories (manage)
                └── Recurring Expenses (upcoming calendar)

Debt ───────────┬── Debts (list + progress)
                └── Payoff Simulator

Investments ────┬── Portfolios (allocation + performance)
                ├── Investments (individual holdings)
                └── Dividend SIPs (automated plans)

Journey ────────┬── Goal Timeline
                ├── Net Worth History
                └── Wealth Score

People ─────────┬── Households (shared finances)
                ├── Conversations (messages)
                └── Trip Mode (shared expenses)

Settings ───────┬── Profile
                ├── Notifications
                ├── Exports
                └── DPDP (privacy)
```

### Tasks
1. **Global nav** — Kubera logo, grouped nav sections, active state indicator
2. **Mobile nav** — bottom tab bar (Dashboard, Money, Debt, Investments, More)
3. **Consistent page layout** — title, optional description, content area

---

## Phase 2: Dashboard — Command Center

**Goal:** At-a-glance financial health with clear next actions.

### Layout
```
┌─────────────────────────────────┐
│ Net Worth: ₹12,84,500  ▲ 2.3%  │  ← hero number with trend
│ [████████████░░░░░] 68%         │  ← debt-free progress bar
│ Debt-free by: Mar 2028          │
├──────────┬──────────┬──────────┤
│ Debt     │ Investm. │ Expenses │  ← 3 stat cards
│ ₹3,20,000│ ₹8,50,000│ ₹45,000  │
│ 5 loans  │ 3 portf. │ 8 recurring│
├──────────┴──────────┴──────────┤
│ Add expense │ Log payment       │  ← quick action chips
├─────────────────────────────────┤
│ Net worth over time [▂▄▆▇▇▆▇█]  │  ← sparkline chart
├─────────────────────────────────┤
│ Recent activity                  │  ← last 5 transactions
│ ▸ Paid ₹12,500 to SBI Card      │
│ ▸ Added ₹50,000 to PPF          │
│ ▸ Electric bill ₹2,400 due tom  │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/dashboard` — all summary data
- `GET /api/v1/dashboard/projection` — 60-month projection

---

## Phase 3: Debts + Payoff Simulator

**Goal:** Clear picture of all debts with payoff momentum.

### Layout
```
┌─────────────────────────────────┐
│ Total Debt: ₹3,20,000           │
│ Monthly EMI: ₹18,500            │
│ Debt-free by: Mar 2028          │
│ Interest saved: ₹1,20,000       │
├─────────────────────────────────┤
│ [+ Add Debt]                    │  ← slide-over form
├─────────────────────────────────┤
│ ┌─ SBI Credit Card ──────────┐  │
│ │ ₹45,000 / ₹1,50,000  ████░░│  │  ← progress card
│ │ 30% paid  |  24% APR       │  │
│ │ Min: ₹5,000  |  Due: 15th  │  │
│ │ [Pay now] [Edit] [Delete]  │  │
│ └────────────────────────────┘  │
│ ┌─ Education Loan ───────────┐  │
│ │ ₹2,75,000 / ₹8,00,000 ███░│  │
│ │ 34% paid  |  8.5% p.a.    │  │
│ │ EMI: ₹12,500 | 48 months   │  │
│ │ [Pay now] [Edit] [Delete]  │  │
│ └────────────────────────────┘  │
├─────────────────────────────────┤
│ Payoff Simulator                 │
│ ┌─ Current: Mar 2028 ────────┐  │
│ │ Extra ₹5,000/mo → Nov 2027  │  │
│ │ Extra ₹10,000/mo → Aug 2027 │  │
│ │ Lump sum ₹50K → Jan 2028    │  │
│ └────────────────────────────┘  │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/debts` — list all debts
- `POST /api/v1/debts` — create debt
- `PATCH /api/v1/debts/:id` — update
- `DELETE /api/v1/debts/:id` — delete
- `POST /api/v1/debt_payoffs/:id/simulate` — what-if payoff

### States
- **Empty**: No debts yet → "Track your first debt. We'll help you plan the payoff."
- **Loading**: 3 skeleton cards
- **Error**: "Could not load debts. [Retry]"

---

## Phase 4: Transactions + Budgeting

**Goal:** Simple money tracking with category budgets.

### Transactions Layout
```
┌─────────────────────────────────┤
│ Monthly Total: ₹62,400          │
│ Budget remaining: ₹12,600      │
├─────────────────────────────────┤
│ [+ Add Transaction]             │
├─────────────────────────────────┤
│ This Month                      │
│ ▸ Jul 10  Groceries      ₹3,200│
│ ▸ Jul 09  Fuel           ₹2,800│
│ ▸ Jul 08  EMI - SBI Card ₹5,000│
│ ▸ Jul 07  Freelance Inc +₹8,000│
│ ...                             │
│ [View all →]                    │
└─────────────────────────────────┘
```

### Budgets Layout
```
┌─────────────────────────────────┐
│ Budget Overview: ₹50K / ₹75K   │  ← 67% used
├─────────────────────────────────┤
│ 🟩 Groceries    ₹8K / ₹10K  80%│
│ 🟨 Dining       ₹4K / ₹5K   80%│
│ 🟥 Shopping     ₹6K / ₹5K  120%│  ← over budget in coral
│ 🟦 Transport    ₹3K / ₹5K   60%│
│ 🟪 Utilities    ₹5K / ₹5K  100%│
│ ...                             │
│ [+ Set Budget]                  │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/transactions` + `GET /api/v1/transactions/monthly_totals`
- `GET /api/v1/budgets/overview` + `GET /api/v1/budgets`
- `GET /api/v1/budget_categories` + `POST /api/v1/budget_categories/seed`

---

## Phase 5: Trip Mode

**Goal:** Simple shared expense tracker for trips (splitwise-light).

### Layout
```
┌─────────────────────────────────┐
│ [Current Trip] ─ [Past Trips]   │  ← tab bar
├─────────────────────────────────┤
│ Goa Trip · Jul 5-9              │
│ 4 members  |  ₹24,500 total    │
│ You're owed: ₹3,200             │
├─────────────────────────────────┤
│ [+ Add Expense] [+ Add Member]  │
├─────────────────────────────────┤
│ Split Summary                    │
│ ▸ You paid:     ₹12,000         │
│ ▸ Your share:   ₹8,800          │
│ ▸ You get back: ₹3,200          │
├─────────────────────────────────┤
│ Expenses                         │
│ ▸ Dinner     ₹4,000   split 4   │
│ ▸ Fuel       ₹2,500   split 4   │
│ ▸ Hotel      ₹12,000  split 2   │
│ ...                             │
├─────────────────────────────────┤
│ Settlements                     │
│ ▸ Anuj owes you    ₹1,200  [✓]  │
│ ▸ Priya owes you   ₹2,000  [✓]  │
└─────────────────────────────────┘
```

### Note: Trip API controllers need to be recreated (models exist, routes/controllers were stripped). Simple CRUD + split logic needed.

---

## Phase 6: Portfolio + Investments + SIPs

**Goal:** All investments in one view regardless of platform.

### Layout
```
┌─────────────────────────────────┐
│ Total: ₹8,50,000  ▲ +₹32,000   │
│ Invested: ₹7,20,000  Return:18%│
├─────────────────────────────────┤
│ [🧩 Allocation]                 │
│ Equity 55%  Debt 25%  Gold 10% │
│ FD 5%  Cash 5%                  │
├─────────────────────────────────┤
│ ┌─ Zerodha ──── +12% ────────┐  │
│ │ ₹3,20,000 → ₹3,58,400      │  │
│ └────────────────────────────┘  │
│ ┌─ PPF ─────── +7.1% ────────┐  │
│ │ ₹1,80,000 → ₹1,92,780      │  │
│ └────────────────────────────┘  │
│ [+ Add Portfolio]               │
├─────────────────────────────────┤
│ Active SIPs                      │
│ ▸ HDFC Midcap   ₹5,000/mo  15th│
│ ▸ PPF           ₹2,500/mo  10th│
│ [+ New SIP]                     │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/portfolios` + rebalance, research
- `GET /api/v1/investments`
- `GET /api/v1/dividend_sips` + suggest

---

## Phase 7: Journey & Projections

**Goal:** Visual timeline to financial freedom.

### Layout
```
┌─────────────────────────────────┐
│ Wealth Score: 72                │
│ ▲ +5 points this quarter        │
├─────────────────────────────────┤
│ Your Financial Journey           │
│                                 │
│ Today ────●─────────────────▶   │
│           │                     │
│    Debt-Free: Mar 2028          │
│    Goal:    5 months early      │
│                                 │
│ Milestones:                      │
│ ✓ ₹1L net worth  (Jan 2026)     │
│ → ₹5L net worth  (Dec 2027)     │
│ → Debt-free      (Mar 2028)     │
│ → ₹10L net worth (Jun 2029)     │
├─────────────────────────────────┤
│ [📈 5-Year Projection]           │
│ ┌─────────────────────────────┐  │
│ │    /\    /\                 │  │
│ │   /  \  /  \  /\            │  │
│ │  /    \/    \/  \           │  │
│ │ /                  \        │  │
│ │/ Debt payoff       net worth│  │
│ └─────────────────────────────┘  │
│ Monthly SIP: ₹15,000  [Adjust]  │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/journey` — current journey data
- `GET /api/v1/journey/progress` — milestones
- `GET /api/v1/journey/net_worth` — net worth timeline
- `GET /api/v1/reports/goal_charts` — goal chart data
- `GET /api/v1/reports/net_worth` — net worth report

---

## Phase 8: Households + Conversations

**Goal:** Shared financial management with family.

### Layout
```
┌─────────────────────────────────┐
│ My Household                     │
│ 3 members  |  Created Jan 2026  │
├─────────────────────────────────┤
│ Members                          │
│ 🟢 You (Admin)                   │
│ 🟢 Anuj (Member)                 │
│ 🟡 Priya (Invited — pending)     │
│ [+ Invite Member]                │
├─────────────────────────────────┤
│ Shared Dashboard                 │
│ Household net worth: ₹15,00,000 │
│ Shared expenses this month: ₹...│
├─────────────────────────────────┤
│ Conversations                    │
│ ▸ "Paid the electricity bill"   │
│   Anuj · 2h ago                 │
│ ▸ "Should we increase SIP?"     │
│   You · 3d ago                  │
└─────────────────────────────────┘
```

### API calls
- `GET /api/v1/households` + members, invite, leave, dashboard
- `GET /api/v1/conversations` + messages

---

## Phase 9: Settings & Utilities

**Goal:** Profile, notifications, exports, privacy.

### Pages
1. **Profile** — name, email, currency, preferences
2. **Notifications** — list with read/unread, mark all read
3. **Exports** — choose: debts / portfolios / transactions / net worth → CSV or JSON
4. **DPDP** — consent status, data export, account erasure request

### API calls
- `GET/POST /api/notification` endpoints
- `GET /api/v1/exports/*` + `POST /api/v1/exports/csv|json`
- `GET/POST /api/dpdp/*` endpoints

---

## Phase 10: Polish & Premium Details

**Goal:** The last 10% that makes it feel expensive.

### Tasks
1. **Skeleton loading** — shape-matched skeletons for every page
2. **Micro-animations** — count-up numbers, card stagger, page transitions
3. **Empty states** — each page gets an illustration + onboarding CTA
4. **Error states** — inline errors, retry buttons, offline indicator
5. **Paper grain overlay** — SVG noise texture (from sri)
6. **Tabular-nums** — all financial figures use `font-variant-numeric: tabular-nums`
7. **Responsive pass** — 375px, 768px, 1024px, 1440px
8. **prefers-reduced-motion** — strip all animations

---

## Implementation Priority

```
Phase 1 ─── Navigation ──────────► NOW (unblocks everything)
Phase 2 ─── Dashboard ───────────► NOW (current home page, biggest impact)
Phase 3 ─── Debts + Payoffs ─────► NOW (core feature, user asked for it)
Phase 4 ─── Transactions + Budgets► NEXT (core money tracking)
Phase 5 ─── Trip Mode ───────────► NEXT (user asked for it, needs API rebuild)
Phase 6 ─── Portfolio + SIPs ────► NEXT
Phase 7 ─── Journey ─────────────► LATER
Phase 8 ─── Households + Chats ──► LATER
Phase 9 ─── Settings ────────────► LATER
Phase 10 ── Polish ──────────────► ONGOING
```

**Per-page UX checklist (every page):**
1. Loading state (skeleton)
2. Empty state (illustration + CTA)
3. Error state (message + retry)
4. Success feedback (subtle, no exclamation)
5. Mobile tap targets ≥ 44x44px
6. Tabular-nums on all ₹ amounts
7. Semantic color: coral = debt/overspend, emerald = growth/savings
