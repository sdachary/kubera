import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Recurring() {
  const [expenses, setExpenses] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/recurring_expenses').then(d => setExpenses(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>8</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Recurring Expenses</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Subscriptions, EMIs, and regular bills.</p>
      {expenses.length === 0 && (
        <div className="empty-state">
          <span className="emoji">↻</span>
          <p>No recurring expenses</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Add your monthly subscriptions and bills so you never miss a payment.</p>
        </div>
      )}
    </div>
  )
}
