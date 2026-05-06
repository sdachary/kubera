# Kubera Repository Evaluation Report

## 1. Code Quality (Ruby / JS / CSS)

**Score: 7/10**

* **Ruby (Backend in `sure/`)**: The Rails codebase follows conventional MVC patterns. Models like `Loan` properly encapsulate business logic (e.g., calculating EMI, remaining months with infinite loop protection, and `Money` objects). The API controllers (`api/v1/*`) are logically separated by feature domains.
* **JavaScript / React**: The root React application uses modern tools (React 19, Vite, Framer Motion) and includes comprehensive testing (`tests/` using Playwright and Vitest). However, the implementation of components (e.g., `DeploymentSteps.jsx`) relies heavily on inline styles mapped from a custom JS design system (`design-system/colors.js`) rather than standard CSS classes or Tailwind. This approach is verbose, harder to maintain, and prone to performance issues compared to utility-first CSS frameworks.
* **CSS**: Custom animations are separated (`src/animations.css`), but the over-reliance on JS-injected inline styles limits the scalability of the UI.

**Recommendations**:
* Migrate from inline styles to Tailwind CSS for the React components to improve developer experience and consistency.
* Consolidate React patterns between the root application and the Rails app if they share the same UI paradigms.

## 2. Architecture (Single Repo with `sure/`)

**Score: 5/10**

* **Structure**: The repository adopts a "Frankenstein" architecture. The root acts as a Vite React application (landing page/frontend), while the `sure/` directory contains an entire monolithic Ruby on Rails application (forked from Maybe Finance).
* **Issues**: 
  * Dependency fragmentation: There are separate `package.json` files in the root and inside `sure/`, leading to duplicate dependencies and confusing build steps.
  * Deployment complexity: Running the application requires navigating into the `sure/` folder and starting Rails, ignoring the root React app, which seems to serve a separate purpose (or is just a landing page wrapper).
  * Fork maintenance: By embedding `sure/` directly rather than as a Git submodule or distinct API backend, upstream updates from the original Sure/Maybe repository will be extremely difficult to merge.

**Recommendations**:
* Decouple the frontend and backend. Extract the `sure/` Rails app to a separate repository (or use Git submodules) and treat it strictly as an API.
* Alternatively, fully integrate the custom React components into the Rails asset pipeline (or Vite Ruby integration) so there is only one unified frontend build process.

## 3. Installer (`installer/install.sh` & `kubera.rb`)

**Score: 4/10**

* **Implementation**: The bash and Ruby installers are basic imperative scripts that clone the repository, run bundle/npm installs, and setup the database.
* **Discrepancies**: The documentation claims the installer is an "interactive TUI" that checks for Docker, detects port conflicts, and guides the user through AI provider setup. None of these features exist in the scripts provided. The `.sh` script simply copies `.env.example` and runs `bin/setup`, while the `.rb` script hardcodes a `git clone` of the upstream `sure` repository (bypassing local `sure/` modifications).
* **Reliability**: They lack proper prerequisite validation (e.g., checking if Postgres, Node, or Ruby are actually installed) and error handling.

**Recommendations**:
* Rewrite the installer to match the documentation's promises (implement an actual TUI using a tool like `gum` or a Ruby CLI framework).
* Add prerequisite checks (Docker, Ruby, Node, Postgres) before attempting installation.
* Fix `kubera.rb` to use the local `sure/` directory rather than cloning from the remote if it already exists within the payload.

## 4. Phase Completeness (v0.1 - v1.0)

**Score: 8/10**

* **v0.1 (Installer/Docker/AI)**: Partially complete. The AI connector and basic setup exist, but the installer lacks the promised polish.
* **v0.2 - v0.5 (Debt, SIP, Portfolio, Recurring)**: Strong completion. The backend endpoints (`debt_payoff_controller.rb`, `dividend_sip_controller.rb`, etc.) and corresponding services are implemented. The database schemas have been migrated appropriately.
* **v1.0 (Full Journey)**: Correctly marked as pending/in-progress. The foundational APIs exist, but the unified dashboard pulling all these metrics together into a single "Zero Day" view is not fully realized in the codebase yet.

**Recommendations**:
* Focus on completing the v1.0 Unified Dashboard to bridge the gap between the modular features (Debt, SIP, Portfolio).

## 5. Documentation (README, USER_FLOW, INSTALL, roadmap)

**Score: 9/10**

* **Quality**: The documentation is excellent. It clearly articulates the product's philosophy ("Debt -> Zero -> Wealth") and provides a compelling differentiation from other finance apps.
* **Flow**: `USER_FLOW.md` offers a vivid, step-by-step mental model of what the user experiences, which serves as a great spec for developers.
* **Accuracy Issues**: The only deduction is for the mismatch between the documented installer features (TUI, Docker checks) and the actual script implementations. 

**Recommendations**:
* Update the `README.md` and `INSTALL.md` to reflect the current reality of the installer scripts, or prioritize updating the scripts to match the documentation.
