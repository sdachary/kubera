# Kubera Technical Debt Report

**Date:** 2026-05-06
**Status:** Evaluation Complete

## Executive Summary
Kubera is in a "Feature Complete" state for v0.4, but suffers from architectural inconsistencies, a major syntax error in the routing system (now fixed), and some security shortcuts. The migration history is excessively large for a project at this stage, and there is duplication in the UI component layer.

---

## 🚩 Critical Issues (Priority: High)

### 1. [FIXED] Broken Routing System
- **Issue:** `config/routes.rb` had multiple extra `end` statements and misaligned namespaces that prevented the application from booting.
- **Impact:** App would not start in any environment.
- **Action Taken:** Surgical removal of redundant blocks and realignment of `api/v1` namespace.

### 2. Hardcoded Security Credentials
- **Issue:** `ApiKey` model contains a hardcoded `DEMO_MONITORING_KEY`.
- **Impact:** Predictable credential that could be exploited if left in production.
- **Recommendation:** Move demo keys to seeds or environment variables.

### 3. API Key Storage Method
- **Issue:** API keys are stored using deterministic encryption (`ActiveRecord::Encryption`) rather than one-way hashing.
- **Impact:** If `SECRET_KEY_BASE` is compromised, all user API keys can be decrypted and stolen.
- **Recommendation:** Use Argon2 or PBKDF2 hashing for API keys (storing only a prefix/last-4 for display).

---

## 🟡 Structural Debt (Priority: Medium)

### 4. UI Component Duplication
- **Issue:** Inconsistency between `app/components/debt_card_component.rb` and `app/components/debt/card_component.rb`.
- **Impact:** Maintenance overhead and "split brain" behavior during UI updates.
- **Recommendation:** Consolidate all ViewComponents into a flat or nested structure and remove duplicates.

### 5. Roadmap vs. Implementation Gap
- **Issue:** `PROGRESS.md` claims v0.2-v0.4 are complete, but `roadmap.md` says v0.2 UI is "IN PROGRESS". Implementation uses Rails ViewComponents while the project seems to be moving towards a React-heavy frontend (Vite at root).
- **Impact:** Confusion for new contributors on which frontend stack to use.
- **Recommendation:** Explicitly define the frontend strategy (Rails ViewComponents vs. React API-driven).

### 6. Installer Inconsistency
- **Issue:** `kubera.rb` and `install.sh` use different logic and hardcode different GitHub URLs.
- **Impact:** Potential for "version drift" depending on which installer a user chooses.
- **Recommendation:** Unify the installation logic into a single source of truth.

---

## 🟢 Maintenance Debt (Priority: Low)

### 7. Excessive Migration History
- **Issue:** 177+ migrations for a relatively young project.
- **Impact:** Slow database setup times and cluttered `db/migrate` directory.
- **Recommendation:** Squash migrations into a clean `schema.rb` and a single initialization migration.

### 8. [FIXED] Malformed Migration Filename
- **Issue:** `20241122183828_change_loan_interest_rate_precision.rb.rb` had a double extension.
- **Action Taken:** Renamed to `.rb`.

### 9. Mocked vs. Real Services
- **Issue:** `DividendScreener` uses a hardcoded stock list.
- **Impact:** Users get realistic-looking but static data.
- **Recommendation:** Integrate with a real market data provider (e.g., Twelve Data or Yahoo Finance) as planned in v1.0.

---

## Priorities for Next Sprint
1. **Security:** Implement one-way hashing for API keys.
2. **Refactor:** Consolidate duplicated ViewComponents.
3. **Architecture:** Decide on and document the definitive Frontend stack.
4. **Reliability:** Add automated syntax checking (linting) to CI to prevent `routes.rb` style errors.
