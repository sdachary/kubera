# Kubera E2E Tests - Debt Payoff Module

## Test Strategy
Tests in this folder verify the full debt payoff journey.

## Prerequisites
- kubera-backend running (Docker or local)
- API key for authentication
- Test database with sample debts

## Test Files

### api/debt_payoff.test.js
Tests the debt payoff API endpoints:
- `GET /api/v1/debt_payoff` - List all debts
- `GET /api/v1/debt_payoff/avalanche` - Avalanche method calculation
- `GET /api/v1/debt_payoff/snowball` - Snowball method calculation
- `GET /api/v1/debt_payoff/simulate?debt_id=X&extra_monthly_payment=Y` - What-if simulation
- `GET /api/v1/debt_payoff/payoff_date?method=avalanche` - Debt-free date projection

### debt_module/debt_list.test.jsx
Tests the debt UI components:
- DebtList renders all debts
- DebtCard shows balance, interest rate, EMI
- PayoffSimulator calculates savings
- Progress indicators update correctly

### e2e/debt_journey.test.js
End-to-end test:
1. User adds a new debt (loan)
2. System calculates avalanche vs snowball
3. User adjusts extra payment
4. System shows new debt-free date
5. Progress tracks monthly

## Running Tests

```bash
# Install deps
npm install

# Run all tests
npm test

# Run specific test
npm test -- debt_payoff
```

## API Test Example

```javascript
// tests/api/debt_payoff.test.js
const axios = require('axios');

const API_BASE = 'http://localhost:3002/api/v1';
const API_KEY = process.env.API_KEY || 'test-key';

const api = axios.create({
  baseURL: API_BASE,
  headers: { 'X-Api-Key': API_KEY }
});

describe('Debt Payoff API', () => {
  test('GET /avalanche returns payoff schedule', async () => {
    const res = await api.get('/debt_payoff/avalanche');
    expect(res.status).toBe(200);
    expect(res.data.method).toBe('avalanche');
    expect(res.data).toHaveProperty('payoff_date');
    expect(res.data).toHaveProperty('total_months');
  });
});
```

## Resume Note
If interrupted, check:
1. `kubera/docs/roadmap.md` - What's done
2. `kubera/PROGRESS.md` - Last task
3. `kubera-backend/` - Latest code changes
