<div align="center">

```
  ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗
  ██║ ██╔╝██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗
  █████╔╝ ██║   ██║██████╔╝█████╗  ██████╔╝███████║
  ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██╔══██╗██╔══██║
  ██║  ██╗╚██████╔╝██████╔╝███████╗██║  ██║██║  ██║
  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
```

**Zero is better than negative.**

Personal finance OS · Self-hosted · Open source

![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)

</div>

---

## What is Kubera?

Kubera is a **standalone, self-hosted personal finance OS** that takes you from **debt → zero → wealth** in a defined timeline.

Most finance apps are either budgeting tools or investment dashboards. Kubera is the full arc:

```
Negative  →  Zero  →  Positive
(in debt)    (free)    (wealthy)
```

The app follows one rule: **clear your liabilities before building wealth.** It doesn't block you — but it always shows debt freedom progress front and center, and investment suggestions only strengthen once debt is under control.

### ✅ Completed Phases (v0.1 → v2.3)
- 🔧 **v0.1** — Single-line installer (`curl ... | bash`), Docker setup, AI connector
- 💳 **v0.2** — Debt Payoff Module (Avalanche/Snowball, EMI calendar, simulation)
- 📈 **v0.3** — Dividend SIP Planner (AI stock suggestions, NSE/BSE screener)
- 🔄 **v0.4** — Portfolio Rebalancing (Modern Portfolio Theory, asset allocation)
- 🔔 **v0.5** — Recurring Expense Tracker (EMI/subscription calendar, notifications)
- 🛡️ **v1.0** — Security audit & standalone architecture
- 🧹 **Phase 6** — Architecture refinement: routes cleanup (442→57 lines), dead code removal, mailer views, initializer simplification, importmap-compatible JS
- 🌍 **v2.0** — Multi-Currency & International Markets (32 currencies, exchange rates, international stock exchanges)
- 🤖 **v2.1** — Advanced AI Features (NL budget creation, transaction categorization, cash flow forecasting, anomaly detection)
- 📊 **v2.2** — Reporting & Export (CSV/JSON export, annual reports, goal charts, income vs expenses)
- 👨‍👩‍👧‍👦 **v2.3** — Collaboration & Sharing (households, member management, shared finances, family dashboard)

- 💳 **Debt payoff tracker** — loans, EMIs, avalanche/snowball strategies
- 📈 **Dividend SIP planner** — AI suggests stocks based on your income target
- 🔄 **Portfolio rebalancing** — monthly check-ins, on/off track status
- 🔔 **Recurring expense reminders** — never miss an EMI or subscription
- 🤖 **Free AI** — works with free models via OpenRouter, or fully local via Ollama
- 🌍 **Multi-currency** — 32 currencies, auto-exchange rates, international exchange support (NYSE, NASDAQ, LSE, TSE, ASX, etc.)
- 💬 **NL budget creation** — "I spent ₹500 on groceries" creates a categorized transaction automatically
- 🔍 **Anomaly detection** — automatically flags unusual spending patterns and budget breaches
- 📊 **Reporting** — CSV/JSON exports, annual tax-ready reports, goal progress charts
- 👨‍👩‍👧‍👦 **Household sharing** — multi-user households with shared tracking and family dashboard
- 🇮🇳 **NSE/BSE support** — built with Indian markets in mind
- 🧹 **Clean architecture** — refined routes (57 lines), no dead code, simplified initializers

---

## Why Kubera? (vs. Other Finance Apps)

| Feature | **Kubera** | YNAB | Mint† | Empower | Rocket Money |
|---------|---------------|------|--------|----------|--------------|
| Self-hosted | ✅ | ❌ | ❌ | ❌ | ❌ |
| Free (no subscription) | ✅ | ❌ ~$15/mo | Was free | Freemium | Freemium |
| **Debt-first philosophy** | ✅ Core | Partial | ❌ | ❌ | ❌ |
| Multi-currency | ✅ 32 currencies | ❌ | ❌ | ❌ | ❌ |
| International exchanges | ✅ NYSE/NASDAQ/LSE/TSE | ❌ | ❌ | ❌ | ❌ |
| Indian markets (NSE/BSE) | ✅ Built-in | ❌ | ❌ | ❌ | ❌ |
| NL transaction creation | ✅ "I spent ₹500" | ❌ | ❌ | ❌ | ❌ |
| Anomaly detection | ✅ 3-sigma algorithm | ❌ | ❌ | ❌ | ❌ |
| Cash flow forecasting | ✅ 12-month projection | ❌ | ❌ | ✅ | ❌ |
| Household sharing | ✅ Multi-user | ❌ | ❌ | ❌ | ✅ |
| Free AI options | ✅ OpenRouter/Ollama | ❌ | ❌ | ❌ | ❌ |
| Local AI (Ollama) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Open source (AGPL-3.0) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Portfolio rebalancing | ✅ | Limited | Basic | ✅ | ❌ |
| SIP planning | ✅ | ❌ | ❌ | ❌ | ❌ |
| Reporting & export | ✅ CSV/JSON/annual | ✅ | ❌ | ✅ | ✅ |

† Mint shut down March 2024

**What makes Kubera different:**
1. **Philosophy-first** — "Debt first, then wealth" isn't a feature, it's the foundation
2. **Your data stays yours** — self-hosted, no surveillance capitalism
3. **Free AI from day one** — no $20/month for AI features
4. **Multi-currency from day one** — 32 currencies, auto-exchange rates, global market support
5. **Built for India** — NSE/BSE, EMIs, SIPs, ₹ currency
6. **Community-driven** — features serve users, not shareholders
7. **Standalone Architecture** — No external dependencies, all data stays local

---

## The Journey

### Phase 1 — Debt Freedom
List all loans and EMIs. Kubera suggests payoff order (avalanche = highest interest first, snowball = smallest balance first). Tracks monthly progress and projects your debt-free date.

### Phase 2 — Foundation Building
Once debt is healthy, SIP suggestions activate. You set a monthly contribution — even ₹500 works. AI picks 2–3 dividend stocks aligned with your timeline and goals.

### Phase 3 — Income Target
You define the goal: *"₹25,000/month passive income by 2030."* Kubera reverse-engineers the path — what SIP amount, which stocks, when to rebalance — and checks in monthly.

---

## Install in One Line

```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/installer/install.sh | bash
```

The installer clones the repo, installs Ruby and Node dependencies, runs setup, and starts the server on `http://localhost:3000`:

- ✅ Clones the repository into `~/kubera`
- ✅ Installs Ruby gems and Node packages
- ✅ Runs `bin/setup` (database creation, migration, seeding)
- ✅ Starts the Rails server on port 3000

---

## AI Assistant — Bring Your Own Key

Kubera works with any OpenAI-compatible endpoint. **Free options work great.**

| Provider | Cost | Notes |
|---|---|---|
| **OpenRouter** | Free tier | Llama 3.1 70B, Gemma 2, Mistral — all free |
| **Ollama** | Free (local) | Runs on your machine, no data leaves |
| **Anthropic** | Paid | Claude — best quality |
| **OpenAI** | Paid | GPT-4o mini — good balance |
| **Custom** | Varies | Any OpenAI-compatible endpoint |

The installer walks you through choosing one. You can also skip and configure later in **Settings → AI Assistant**.

---

## Architecture

Kubera is a **native Rails 7.2 application** built for self-hosting.

- **Frontend**: Tailwind CSS + Hotwire (Turbo/Stimulus)
- **Backend**: Ruby on Rails, PostgreSQL, Redis
- **Background jobs**: Sidekiq with cron schedules for market data, exchange rates, and maintenance
- **Security**: Local-only data storage, no external bank sync required
- **AI**: Pluggable architecture supporting local (Ollama) and cloud (OpenRouter) models
- **Multi-currency**: Exchange rates cached from Yahoo Finance, updated every 6 hours
- **Export**: CSV and JSON export for all financial modules
- **Households**: Multi-user sharing with role-based access control

---

## Manual Setup

Prefer to set it up yourself?

```bash
git clone https://github.com/sdachary/kubera.git
cd kubera
cp .env.example .env
# Edit .env — set SECRET_KEY_BASE and POSTGRES_PASSWORD at minimum
docker compose up -d
open http://localhost:3002
```

---

## Roadmap

See [docs/roadmap-updated.md](docs/roadmap-updated.md) for the full plan.

- ✅ v0.1 — Installer + Docker setup + AI connector
- ✅ v0.2 — Debt payoff module
- ✅ v0.3 — Dividend SIP planner
- ✅ v0.4 — Portfolio rebalancing
- ✅ v0.5 — Recurring expense tracker
- ✅ v1.0 — Security audit & standalone architecture
- ✅ Phase 6 — Architecture refinement (routes, dead code, mailers, initializers)
- ✅ v2.0 — Multi-Currency & International Markets
- ✅ v2.1 — Advanced AI Features (NL budgets, categorization, forecasting, anomaly detection)
- ✅ v2.2 — Reporting & Export (CSV/JSON, annual reports, goal charts)
- ✅ v2.3 — Collaboration & Sharing (households, multi-user, family dashboard)

---

## Why Open Source?

1. **Your Data Stays Yours** — Self-hosted, no subscription fees, no data mining
2. **Audit Your Finances** — Full transparency: inspect the code that handles your money
3. **No Vendor Lock-in** — Fork it, modify it, host it forever
4. **Community-Driven** — Features serve users, not shareholders
5. **AGPL-3.0 Licensed** — Any hosted version must share improvements
6. **Free AI Options** — Unlike commercial apps, no forced subscriptions for AI features
7. **Contribute Back** — Add exchange support, improve debt algorithms, share with everyone

---

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a PR.

The short version: contributions should serve the philosophy — debt first, then wealth. Features that undermine that priority won't be merged regardless of technical quality.

---

## License

[AGPL-3.0](LICENSE) — Fork freely, contribute back when you can.

---

*Kubera (कुबेर) is the Hindu god of wealth and treasurer of the gods.*
*The name is aspirational — but you have to get to zero first.*

