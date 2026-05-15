# Phase 1: Environment Stabilization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal**: Resolve native gem build issues (specifically `io-console`) and complete `bundle install` to enable local testing and linting.

**Architecture**: Identify and install missing system dependencies for Ruby native extensions, then verify the environment with Rubocop and RSpec.

**Tech Stack**: Ruby, Bundler, apt-get (system packages).

---

### Task 1: Resolve Native Gem Build Issues

**Files**:
- Modify: `plans/kubera-plan.md` (Track progress)

- [ ] **Step 1: Identify missing system headers**
    Run: `gem install io-console -v 0.8.2 --verbose`
    Expected: FAIL with a specific error message about missing headers (e.g., `ruby.h` or `io/console`).

- [ ] **Step 2: Install required system packages**
    Since I'm on Linux, I'll attempt to install `ruby-dev` and `build-essential`.
    Run: `sudo apt-get update && sudo apt-get install -y ruby-dev build-essential libpq-dev`
    *Note: If sudo is not available, I will try to use a pre-compiled version of the gem or check if a different Ruby version resolves it.*

- [ ] **Step 3: Complete bundle install**
    Run: `ruby bin/bundle install`
    Expected: SUCCESS (All gems installed).

- [ ] **Step 4: Update Progress**
    Mark "Fix native gem builds" as complete in `plans/kubera-plan.md`.

- [ ] **Step 5: Commit**
    ```bash
    git add plans/kubera-plan.md
    git commit -m "chore: environment stabilization - fixed gem builds"
    ```

### Task 2: Verify Linting & Testing

**Files**:
- Modify: `plans/kubera-plan.md` (Track progress)

- [ ] **Step 1: Run Rubocop**
    Run: `bin/rubocop`
    Expected: Output with linting results (should run now that gems are installed).

- [ ] **Step 2: Run RSpec**
    Run: `bin/bundle exec rspec`
    Expected: Output with test results.

- [ ] **Step 3: Update Progress**
    Mark "Verify Linting" and "Verify Testing" as complete in `plans/kubera-plan.md`.

- [ ] **Step 4: Commit**
    ```bash
    git add plans/kubera-plan.md
    git commit -m "chore: verified environment with linting and testing"
    ```
