# Kubera Repository Structure

## Overview
Kubera uses a **two-repo approach**:
- **kubera/** (this repo) - Marketing site, installer, docs, tests
- **kubera-backend/** (fork of Sure) - Rails API backend

## Directory Structure

```
kubera/                    ← This repo (github.com/deepakachary/kubera)
├── compose.yml            # Points to kubera-backend Docker image
├── install.sh            # Interactive installer
├── src/                  # React marketing site
├── docs/                 # Documentation + roadmap
├── tests/                # E2E tests for full stack
│   ├── api/             # API integration tests
│   ├── debt_module/      # Debt payoff feature tests
│   └── e2e/             # End-to-end browser tests
└── README.md

kubera-backend/           ← Separate repo (fork of Sure)
├── app/
│   ├── models/loan.rb   # Extended with debt methods
│   ├── services/debt_payoff_calculator.rb
│   └── controllers/api/v1/debt_payoff_controller.rb
└── db/migrate/          # Debt fields migration
```

## Development Workflow

### Local Development
1. Clone both repos:
   ```bash
   git clone https://github.com/deepakachary/kubera.git
   git clone https://github.com/deepakachary/kubera-backend.git
   ```

2. Update `compose.yml` to build locally:
   ```yaml
   services:
     web:
       build: ../kubera-backend  # Local path for development
   ```

3. Run tests from kubera/tests/:
   ```bash
   cd kubera/tests && npm test
   ```

### Production
- `compose.yml` pulls from `ghcr.io/deepakachary/kubera-backend:stable`
- kubera-backend auto-builds on push via GitHub Actions

## Test Strategy

Tests in **kubera/tests/** cover:
1. **API Tests** - Debt payoff endpoints
2. **E2E Tests** - Full user journey (add debt → see payoff plan)
3. **Integration Tests** - EMI tracking with transactions

## Resume After Interruption

1. Check roadmap: `cat docs/roadmap.md`
2. Check progress: `cat PROGRESS.md`
3. Continue from last completed task
4. Update `PROGRESS.md` after each task

## Current Status (2026-05-02)

- [x] Fork Sure → kubera-backend
- [x] Add debt fields to loans table
- [x] Create DebtPayoffCalculator service
- [x] Add debt API endpoints
- [ ] Create E2E tests in kubera/tests/
- [ ] Build debt UI components (frontend agent working)
