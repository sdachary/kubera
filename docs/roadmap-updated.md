# Kubera Roadmap

**From debt → zero → wealth.** The roadmap follows the same philosophy: debt first, then wealth.

## ✅ Completed

### v0.1 — Foundation (Installer + Docker + AI)
- Single-line installer (`curl ... | bash`)
- Docker Compose setup (PostgreSQL, Rails, Sidekiq)
- AI connector (OpenAI-compatible: OpenRouter, Ollama, Claude)
- First-boot auto-setup (user creation, migrations)

### v0.2 — Debt Payoff Module
- Debt CRUD (loans, credit cards, EMIs)
- Avalanche & Snowball payoff strategies
- Month-by-month payoff schedule simulation
- Debt-free date projection (zero-day target)

### v0.3 — Dividend SIP Planner
- Dividend stock screener (Yahoo Finance integration)
- Weighted scoring (yield 60% / growth 40%)
- SIP allocation recommendations
- AI-assisted stock suggestions

### v0.4 — Portfolio Rebalancing
- Modern Portfolio Theory (expected return, volatility, Sharpe ratio)
- Asset allocation tracking
- Monthly rebalance check-ins (on/off track)
- Pluggable market data providers (Yahoo Finance, Twelve Data, Alpha Vantage)

### v0.5 — Recurring Expense Tracker
- EMI/subscription calendar
- Notification system (Sidekiq workers)
- Recurring expense CRUD
- Monthly expense aggregation

### v1.0 — Security & Standalone Architecture
- Security audit hardening
- No external dependencies (all data stays local)
- BCrypt/Argon2 authentication
- CORS configuration

### Phase 6 — Architecture Refinement
- **Routes cleanup**: 442→57 lines, removed ~75 dead route entries
- **JS modernization**: importmap-compatible Stimulus, removed dead `services/`/`utils/`
- **Mailer views**: ApplicationMailer + 4 notification templates
- **Dead code removal**: 17 stale rake tasks, 12 stale initializers, UI design tokens package
- **Gemfile cleanup**: Sidekiq, Sidekiq-Cron, Rack-CORS
- **Request specs**: Fixed all 5 request specs to hit correct API URLs
- **Initializers**: Simplified CORS, Sidekiq, Auth; removed stale references

### Landing Page (May 2026)
- Scroll-driven amber→sage color transition (OKLCH)
- Liabilities-to-assets narrative
- Curl command CTA (`curl -s https://api.kubera.com/v1/start`)
- Responsive design, mobile hamburger, reduced-motion support

## 🔜 Upcoming

### v2.0 — Multi-Currency & International Markets
- Multi-currency support (USD, EUR, GBP, etc.)
- International stock exchanges (NYSE, NASDAQ, LSE)
- Exchange rate auto-updates
- Currency-aware net worth calculation

### v2.1 — Advanced AI Features
- natural language budget creation from chat
- AI-powered spending categorization
- Predictive cash flow forecasting
- Anomaly detection (unusual transactions)

### v2.2 — Reporting & Export
- PDF/CSV export for all modules
- Annual financial report (tax-ready)
- Custom date-range reporting
- Goal progress charts

### v2.3 — Collaboration & Sharing
- Multi-user household support
- Shared debt/investment tracking
- Permission-based access control
- Family financial dashboard

### v2.4 — Mobile Companion
- PWA with offline support
- Push notifications (EMI reminders, rebalance alerts)
- Quick-log for expenses
- Biometric auth

## 🧠 Philosophy

Every feature must serve the core philosophy: **clear liabilities before building wealth.** Features that undermine this priority won't be merged regardless of technical quality.
