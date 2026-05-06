# Kubera AI Evaluation Summary

*Date:** 2026-05-06
*Evaluated by:** Claude Code (Frontend Agent) + Gemini CLI (TypeScript Agent)
*Via:** mcp-hub (MCP Hub)

---

## 📊 Overall Scores

| Category | Score | Weight |
|----------|-------|--------|
| Code Quality | 7/10 | 20% |
| Architecture | 5/10 | 25% |
| Installer | 4/10 | 15% |
| Phase Completeness | 8/10 | 25% |
| Documentation | 9/10 | 15% |
| **Weighted Average** | **6.65/10** | **100%** |

---

## ✅ Strengths

1. **Feature-Rich:** v0.2-v0.5 fully implemented (Debt, SIP, Portfolio, Expenses)
2. **Excellent Docs:** USER_FLOW.md, INSTALL.md, roadmap.md are world-class
3. **Functional APIs:** All v0.2-v1.0 endpoints working (/debt_payoff, /dividend_sip, /journey)
4. **AI Integration:** OpenRouter connector ready

---

## ❌ Critical Issues (Must Fix)

### 1. Architecture: "Frankenstein" (Score: 5/10)
- **Problem:** Root is Vite React app, `sure/` is entire Rails monolith
- **Impact:** Confusing, hard to deploy, difficult to merge upstream Sure updates
- **Fix:** Decouple → Rails API + Separate React frontend (or fully integrate)

### 2. Security: Hardcoded Keys (Gemini Report)
- **Problem:** `DEMO_MONITORING_KEY` hardcoded in `ApiKey` model
- **Problem:** API keys use deterministic encryption (not one-way hashing)
- **Impact:** If `SECRET_KEY_BASE` compromised, all user keys decryptable
- **Fix:** Remove hardcoded keys, use Argon2 hashing for API keys

### 3. Installer-Docs Gap (Score: 4/10)
- **Problem:** Docs promise TUI, Docker checks, port detection → Scripts just `git clone`
- **Fix:** Rewrite installer to match docs, or update docs to reflect reality

---

## 🔧 Medium Priority

### 4. UI Component Duplication
- **Problem:** `app/components/debt_card_component.rb` vs `app/components/debt/card_component.rb`
- **Fix:** Consolidate into single structure

### 5. Frontend Strategy Confusion
- **Problem:** Root uses React + custom JS styles, `sure/` uses Rails ViewComponents + inline styles
- **Fix:** Pick one stack (React + Tailwind OR Rails + Hotwire)

### 6. Migration Bloat
- **Problem:** 177+ migrations (forked from Sure/Maybe)
- **Fix:** Squash migrations for fresh installs (keep history in separate branch)

---

## 📈 Low Priority

### 7. Inline Styles Overuse (Claude Report: 7/10)
- **Problem:** React components use custom `design-system/colors.js` instead of Tailwind
- **Fix:** Migrate to Tailwind CSS for maintainability

### 8. Roadmap vs. Progress Gap
- **Problem:** `roadmap.md` says v0.2 UI "IN PROGRESS", `PROGRESS.md` says "COMPLETED"
- **Fix:** Unify tracking in single source of truth

---

## 🎯 Recommended Action Plan

### Immediate (This Week)
1. **Fix Security:** Remove hardcoded `DEMO_MONITORING_KEY`, audit `ApiKey` encryption
2. **Unify Frontend:** Choose React (Vite) OR Rails (ViewComponents), not both
3. **Fix Installer:** Either implement promised TUI or update docs

### Short Term (Next 2 Weeks)
4. **Complete v1.0:** Build unified dashboard pulling debt + SIP + portfolio
5. **Consolidate UI:** Remove duplicate components (`debt/` vs `debt_*_component`)
6. **Squash Migrations:** Create clean slate for new users

### Long Term (Next Month)
7. **Decouple Architecture:** Extract `sure/` to separate repo (or make it pure API)
8. **Add Tests:** Increase coverage for v0.2-v0.5 features
9. **Deploy Strategy:** Figure out how to deploy the "Frankenstein" (Docker? Submodules?)

---

## 💡 Final Verdict

> **Kubera is a feature-complete v0.5 with excellent documentation, but suffers from architectural inconsistency and security shortcuts. The codebase works, but needs structural cleanup to scale safely.**

**Next Milestone:** Complete v1.0 (Unified Dashboard) with cleaned-up architecture.
