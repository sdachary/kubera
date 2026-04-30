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

[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)
[![Built on Sure](https://img.shields.io/badge/built%20on-Sure-orange.svg)](https://github.com/we-promise/sure)

</div>

---

## What is Kubera?

Kubera is a self-hosted personal finance OS that takes you from **debt → zero → wealth** in a defined timeline.

Most finance apps are either budgeting tools or investment dashboards. Kubera is the full arc:

```
Negative  →  Zero  →  Positive
(in debt)    (free)    (wealthy)
```

The app follows one rule: **clear your liabilities before building wealth.** It doesn't block you — but it always shows debt freedom progress front and center, and investment suggestions only strengthen once debt is under control.

Built on top of [Sure](https://github.com/we-promise/sure), Kubera adds:

- 🎯 **Debt payoff tracker** — loans, EMIs, avalanche/snowball strategies
- 📈 **Dividend SIP planner** — AI suggests stocks based on your income target
- 🔄 **Portfolio rebalancing** — monthly check-ins, on/off track status
- 🔔 **Recurring expense reminders** — never miss an EMI or subscription
- 🤖 **Free AI** — works with free models via OpenRouter, or fully local via Ollama
- 📊 **NSE/BSE support** — built with Indian markets in mind

---
## Acknowledgements

Kubera is built on [Sure](https://github.com/we-promise/sure),
which is itself a fork of [Maybe Finance](https://github.com/maybe-finance/maybe).
Both are licensed under AGPL-3.0.

## Install in one line

```bash
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash
```

The installer is an interactive TUI — no documentation reading required:

- ✅ Checks for Docker, offers to install if missing
- ✅ Detects port conflicts, suggests free alternatives
- ✅ Walks you through AI provider setup (or skip for later)
- ✅ Generates all config files with secure random keys
- ✅ Pulls Docker images and starts everything

**Other commands:**

```bash
# Update to latest
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash -s update

# View logs
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash -s logs

# Check status
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash -s status

# Uninstall
curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/install.sh | bash -s uninstall
```

---

## AI assistant — bring your own key

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

## The journey

**Phase 1 — Debt Freedom**

List all loans and EMIs. Kubera suggests payoff order (avalanche = highest interest first, snowball = smallest balance first). Tracks monthly progress and projects your debt-free date.

**Phase 2 — Foundation Building**

Once debt is healthy, SIP suggestions activate. You set a monthly contribution — even ₹500 works. AI picks 2–3 dividend stocks aligned with your timeline and goals.

**Phase 3 — Income Target**

You define the goal: *"₹25,000/month passive income by 2030."* Kubera reverse-engineers the path — what SIP amount, which stocks, when to rebalance — and checks in monthly.

---

## Manual setup

Prefer to set it up yourself? See [docs/manual-setup.md](docs/manual-setup.md).

```bash
git clone https://github.com/sdachary/kubera.git
cd kubera
cp .env.example .env
# Edit .env — set SECRET_KEY_BASE and POSTGRES_PASSWORD at minimum
docker compose up -d
open http://localhost:3000
```

---

## Roadmap

See [docs/roadmap.md](docs/roadmap.md) for the full plan.

- ✅ v0.1 — Installer + Docker setup + AI connector
- 🔄 v0.2 — Debt payoff module
- 🔄 v0.3 — Dividend SIP planner
- 🔄 v0.4 — Portfolio rebalancing
- 🔄 v0.5 — Recurring expense tracker
- 🔄 v1.0 — Full debt → wealth journey

---

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a PR.

The short version: contributions should serve the philosophy — debt first, then wealth. Features that undermine that priority won't be merged regardless of technical quality.

---

## Acknowledgements

Kubera is built on [Sure](https://github.com/we-promise/sure), which is built on [Maybe Finance](https://github.com/maybe-finance/maybe). We're standing on good foundations.

---

## License

[AGPL-3.0](LICENSE) — same as Sure and Maybe. Fork freely, contribute back when you can.

---

*Kubera (कुबेर) is the Hindu god of wealth and treasurer of the gods.*
*The name is aspirational — but you have to get to zero first.*
