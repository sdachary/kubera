# Frontend Decision: Hotwire (Turbo + Stimulus)

## Decision

Use **Rails 7.2 + Hotwire** (Turbo + Stimulus) + Tailwind CSS for the frontend. No React, no Vite, no separate SPA.

## Rationale

| Factor | Hotwire | React/Vite SPA |
|--------|---------|----------------|
| Complexity | Low — server-rendered HTML with progressive enhancement | High — separate build pipeline, state management, routing |
| Dependencies | Built into Rails (turbo-rails, stimulus-rails) | npm packages (react, react-dom, react-router, etc.) |
| Build time | ~2s (asset pipeline) | ~10-30s (Vite/Webpack) |
| Bundle size | ~100KB (Turbo + Stimulus) | ~200KB+ (React + ecosystem) |
| SEO | Natural — server-rendered HTML | Requires SSR/SSG |
| Accessibility | Standard HTML semantics | ARIA-dependent |
| Maintenance | Minimal — 2 packages | ~10+ packages with frequent breaking changes |
| Learning curve | Low for Rails developers | Medium-high |

## When to Revisit

- If the UI needs complex client-side interactivity (e.g., drag-and-drop spreadsheet, real-time collaborative editing)
- If offline-first capability becomes a requirement
- If third-party integrations demand a decoupled API client

As of v2.3, none of these conditions apply.
