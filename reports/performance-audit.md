# Performance Audit Report - Kubera Personal Finance OS

## Overview
This document provides step-by-step instructions for setting up Lighthouse CI, monitoring Core Web Vitals, and profiling animation performance.

---

## Target Metrics (from PRD Section 7)

| Metric | Target | Current |
|--------|--------|---------|
| Lighthouse Performance | >= 90 | |
| Lighthouse Accessibility | >= 95 | |
| Lighthouse Best Practices | >= 95 | |
| Lighthouse SEO | >= 100 | |
| LCP (Largest Contentful Paint) | < 2.5s | |
| FID (First Input Delay) | < 100ms | |
| CLS (Cumulative Layout Shift) | < 0.1 | |
| Animation FPS | >= 60fps | |

---

## Step 1: Lighthouse CI Setup

### 1.1 Install Lighthouse CI
```bash
npm install -g @lhci/cli @lhci/assert
# OR local install
npm install --save-dev @lhci/cli @lhci/assert
```

### 1.2 Create Lighthouse Configuration
Create `.lighthouserc.js` or `.lighthouserc.json` in project root:

```javascript
// .lighthouserc.js
module.exports = {
  ci: {
    collect: {
      // URL to test (use local dev server)
      url: ['http://localhost:3000'],
      numberOfRuns: 3,
      // Collect settings
      settings: {
        preset: 'desktop',  // or 'mobile'
        onlyCategories: ['performance', 'accessibility', 'best-practices', 'seo'],
        formFactor: 'desktop',
        screenEmulation: {
          mobile: false,
          width: 1920,
          height: 1080,
          deviceScaleFactor: 1
        }
      },
      // Start local server before auditing
      startServerCommand: 'npm run dev',
      startServerReadyPattern: 'Local:',
    },
    assert: {
      assertions: {
        // Performance
        'categories:performance': ['error', { minScore: 0.90 }],
        // Accessibility
        'categories:accessibility': ['error', { minScore: 0.95 }],
        // Best Practices
        'categories:best-practices': ['error', { minScore: 0.95 }],
        // SEO
        'categories:seo': ['error', { minScore: 1.0 }],
        // Core Web Vitals
        'largest-contentful-paint': ['error', { maxNumericValue: 2500 }],
        'first-input-delay': ['error', { maxNumericValue: 100 }],
        'cumulative-layout-shift': ['error', { maxNumericValue: 0.1 }],
        // Additional checks
        'uses-optimized-images': 'warn',
        'uses-webp-images': 'warn',
        'uses-responsive-images': 'warn',
        'total-byte-weight': ['warn', { maxNumericValue: 500 * 1024 }], // 500KB
      }
    },
    upload: {
      // Upload results to Lighthouse CI server (optional)
      target: 'temporary-public-storage',
      // Or use Lighthouse CI server
      // serverBaseUrl: 'http://localhost:9001',
    }
  }
};
```

### 1.3 Add NPM Scripts
```json
{
  "scripts": {
    "lhci:collect": "lhci collect",
    "lhci:assert": "lhci assert",
    "lhci:upload": "lhci upload",
    "lhci": "lhci autorun",
    "perf:audit": "lighthouse http://localhost:3000 --output=html --output-path=./reports/lighthouse.html"
  }
}
```

### 1.4 Run Lighthouse CI
```bash
# Start dev server in one terminal
npm run dev

# Run Lighthouse CI in another terminal
npm run lhci

# Or run single audit
npm run perf:audit
```

---

## Step 2: Core Web Vitals Monitoring

### 2.1 Install Web Vitals Library
```bash
npm install web-vitals
```

### 2.2 Create Web Vitals Reporter
Create `src/utils/reportWebVitals.js`:

```javascript
import { getCLS, getFID, getLCP, getFCP, getTTFB } from 'web-vitals';

function sendToAnalytics({ name, value, id }) {
  // Send to your analytics platform
  // Example: Google Analytics 4
  if (typeof gtag !== 'undefined') {
    gtag('event', name, {
      value: Math.round(name === 'CLS' ? value * 1000 : value),
      metric_id: id,
      metric_value: value,
    });
  }
  
  // Console logging for development
  console.log(`[Web Vital] ${name}:`, value);
}

export function reportWebVitals() {
  getCLS(sendToAnalytics);
  getFID(sendToAnalytics);
  getLCP(sendToAnalytics);
  getFCP(sendToAnalytics);
  getTTFB(sendToAnalytics);
}
```

### 2.3 Integrate in Entry Point
In `src/main.jsx` or `index.js`:
```javascript
import { reportWebVitals } from './utils/reportWebVitals';

reportWebVitals();
```

### 2.4 Real User Monitoring (RUM)
```javascript
// More detailed RUM setup
import { getCLS, getFID, getLCP } from 'web-vitals';

function logMetric(metric) {
  const body = JSON.stringify({
    name: metric.name,
    value: metric.value,
    id: metric.id,
    navigationType: metric.navigationType,
  });

  // Use sendBeacon for reliable delivery
  if (navigator.sendBeacon) {
    navigator.sendBeacon('/api/analytics', body);
  }
}

getCLS(logMetric);
getFID(logMetric);
getLCP(logMetric);
```

---

## Step 3: Animation Performance Profiling

### 3.1 Browser DevTools Profiling
1. Open Chrome DevTools
2. Go to **Performance** tab
3. Click **Record** (or Ctrl+Shift+E)
4. Interact with animations (scroll, hover, click)
5. Stop recording
6. Analyze FPS chart (should be >= 60fps)
7. Look for long tasks (> 50ms)

### 3.2 Check GPU-Accelerated Properties
Animations should ONLY use:
- ✅ `transform` (translate, scale, rotate, skew)
- ✅ `opacity`

Avoid animating (causes layout thrashing):
- ❌ `width`, `height`
- ❌ `top`, `left`, `right`, `bottom`
- ❌ `margin`, `padding`
- ❌ `background-color`

### 3.3 Framer Motion Optimization
```javascript
// Good - uses transform/opacity
<motion.div
  animate={{ x: 100, opacity: 0.5 }}
  transition={{ type: 'spring', stiffness: 300 }}
/>

// Avoid - animates layout properties
// (Framer Motion handles this with layout prop, but be careful)
```

### 3.4 prefers-reduced-motion Check
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Test in DevTools:
1. Open DevTools > Rendering
2. Check "Emulate CSS media feature prefers-reduced-motion: reduce"
3. Refresh page
4. Verify animations are disabled

### 3.5 Performance Observer API
```javascript
// Monitor long tasks
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) {
      console.warn('Long task detected:', entry.duration, 'ms');
    }
  }
});

observer.observe({ entryTypes: ['longtask'] });

// Monitor layout shifts
const clsObserver = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (!entry.hadRecentInput) {
      console.log('Layout shift:', entry.value);
    }
  }
});

clsObserver.observe({ entryTypes: ['layout-shift'] });
```

---

## Step 4: Bundle Size Analysis

### 4.1 Install Bundle Analyzer
```bash
npm install --save-dev rollup-plugin-visualizer webpack-bundle-analyzer
# For Vite:
npm install --save-dev vite-plugin-visualizer
```

### 4.2 Configure Vite Bundle Analyzer
```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { visualizer } from 'vite-plugin-visualizer';

export default defineConfig({
  plugins: [
    react(),
    visualizer({
      filename: './reports/bundle-stats.html',
      open: true,
      gzipSize: true,
    })
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          framer: ['framer-motion'],
        }
      }
    }
  }
});
```

### 4.3 Analyze Bundle
```bash
npm run build
# Check dist/assets for file sizes
ls -lh dist/assets/

# Target sizes:
# - Main JS bundle: < 200KB gzipped
# - CSS bundle: < 50KB gzipped
```

---

## Step 5: Image Optimization

### 5.1 Check Image Sizes
```bash
# Find large images
find src -name "*.png" -o -name "*.jpg" | xargs ls -lh

# Target: images should be < 200KB each
```

### 5.2 Optimize Images
```bash
# Install imagemin tools
npm install --save-dev imagemin imagemin-webp imagemin-mozjpeg imagemin-pngquant

# Convert to WebP
npm install --save-dev vite-plugin-imagemin
```

### 5.3 Responsive Images
```html
<picture>
  <source srcset="image-320.webp" media="(max-width: 320px)" type="image/webp">
  <source srcset="image-768.webp" media="(max-width: 768px)" type="image/webp">
  <img src="image.jpg" alt="Description" loading="lazy" width="800" height="600">
</picture>
```

---

## Step 6: Performance Budget

Create `performance-budget.json`:
```json
{
  "budgets": [
    {
      "path": "/*",
      "timings": [
        { "metric": "interactive", "budget": 3000 },
        { "metric": "first-contentful-paint", "budget": 1500 },
        { "metric": "largest-contentful-paint", "budget": 2500 }
      ],
      "resourceSizes": [
        { "resourceType": "script", "budget": 200 },
        { "resourceType": "stylesheet", "budget": 50 },
        { "resourceType": "image", "budget": 500 }
      ],
      "resourceCounts": [
        { "resourceType": "script", "budget": 10 },
        { "resourceType": "stylesheet", "budget": 2 }
      ]
    }
  ]
}
```

---

## Step 7: CI/CD Integration

### 7.1 GitHub Actions Example
```yaml
# .github/workflows/performance.yml
name: Performance Audit

on: [push, pull_request]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run build
      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli
          lhci autorun
        env:
          LHCI_GITHUB_APP_TOKEN: ${{ secrets.LHCI_GITHUB_APP_TOKEN }}
```

### 7.2 Lighthouse CI Server (Optional)
```bash
# Run Lighthouse CI server for tracking over time
npm install -g @lhci/cli
lhci server --port=9001
```

---

## Performance Checklist

### Before Deployment
- [ ] Lighthouse Performance >= 90
- [ ] Lighthouse Accessibility >= 95
- [ ] Lighthouse Best Practices >= 95
- [ ] Lighthouse SEO = 100
- [ ] LCP < 2.5s (lab test)
- [ ] FID < 100ms (lab test)
- [ ] CLS < 0.1 (lab test)
- [ ] Bundle size < 200KB gzipped
- [ ] All images optimized and using WebP
- [ ] Animations run at 60fps
- [ ] prefers-reduced-motion respected
- [ ] No console errors or warnings
- [ ] No layout shifts during page load

### Post-Deployment Monitoring
- [ ] Set up RUM for real user Web Vitals
- [ ] Monitor Core Web Vitals in Google Search Console
- [ ] Set up alerts for performance regression
- [ ] Regular Lighthouse audits (weekly/monthly)

---

## Common Performance Issues & Fixes

| Issue | Cause | Fix |
|-------|------|-----|
| Low LCP | Large hero image, render-blocking CSS/JS | Optimize images, defer non-critical CSS/JS |
| High FID | Heavy JS execution, long tasks | Code split, defer non-critical JS |
| High CLS | Images without dimensions, dynamic content | Set width/height on images, reserve space |
| Low FPS | Animations on non-GPU properties | Only animate transform/opacity |
| Large Bundle | Unused code, duplicate dependencies | Tree shake, code split, analyze bundle |

---

## Report History

| Date | Lighthouse Perf | LCP | FID | CLS | Bundle Size | Notes |
|------|----------------|-----|-----|-----|-------------|-------|
| | | | | | | |
| | | | | | | |
| | | | | | | |

---

**Performance Auditor**: _________________ **Date**: _________

**Approved for Production**: _________________ **Date**: _________
