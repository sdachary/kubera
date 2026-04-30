# Contributing to Kubera

Thanks for wanting to contribute. Kubera is built on a clear philosophy — debt first, then wealth — and the best contributions are ones that serve that arc.

## Philosophy first

Before opening a PR, ask: *does this help someone move from negative → zero → positive?*

Features that fit:
- Better debt payoff tracking and visualisation
- Smarter dividend SIP suggestions
- Clearer goal progress and milestone moments
- Support for more markets (NSE/BSE, other exchanges)
- Better AI prompts and financial reasoning
- Installer improvements (new distros, edge cases, UX)

Features that don't fit (for now):
- General budgeting features (Sure handles this upstream)
- Crypto tracking
- Social/sharing features

## Getting started

### 1. Fork and clone

```bash
git clone https://github.com/YOUR_USERNAME/kubera.git
cd kubera
```

### 2. Run locally

```bash
# Install using the local script
bash install.sh

# Or manually
cp compose.example.yml compose.yml
cp .env.example .env
# Fill in .env — SECRET_KEY_BASE and POSTGRES_PASSWORD are required
docker compose up
```

Visit http://localhost:3000

### 3. Make your changes

Kubera extends [Sure](https://github.com/we-promise/sure). Most application code lives upstream. Kubera-specific additions will live in:

```
kubera/
├── install.sh              ← Installer TUI
├── compose.example.yml     ← Docker config
├── docs/
│   ├── hosting/            ← Self-hosting guides
│   ├── features/           ← Feature documentation
│   └── roadmap.md
└── scripts/
    ├── update.sh           ← Update helper
    └── backup.sh           ← Backup helper
```

## Submitting changes

1. Create a branch: `git checkout -b feat/your-feature-name`
2. Make your changes
3. Test the installer if you touched `install.sh`:
   ```bash
   bash -n install.sh   # syntax check
   bash install.sh      # full run
   ```
4. Open a PR with a clear description of what and why

## Issues

Use the issue templates:
- 🐛 **Bug report** — something broken
- 💡 **Feature request** — something missing
- 📖 **Docs** — something unclear

## Code of conduct

Be direct. Be kind. Disagree on ideas, not people.

## License

By contributing, you agree your contributions will be licensed under AGPL-3.0.
