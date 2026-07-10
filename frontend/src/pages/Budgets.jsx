import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Budgets() {
  const [budgets, setBudgets] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/budgets').then(d => setBudgets(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>7</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Budgets</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Set limits and stay on track.</p>
      {budgets.length === 0 && (
        <div className="empty-state">
          <span className="emoji">□</span>
          <p>No budgets set yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Create a budget to track spending by category.</p>
        </div>
      )}
    </div>
  )
}
