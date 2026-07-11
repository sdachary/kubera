import { useState, useEffect } from 'react'
import { api } from '../lib/api'

function daysText(days) {
  if (days === null || days === undefined) return ''
  if (days === 0) return 'Due today'
  if (days === 1) return 'Due tomorrow'
  if (days < 0) return `${Math.abs(days)} day${Math.abs(days) > 1 ? 's' : ''} overdue`
  return `${days} day${days > 1 ? 's' : ''} away`
}

export default function Recurring() {
  const [expenses, setExpenses] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/recurring_expenses').then(d => setExpenses(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      {[1,2,3].map(i => <div key={i} className="skeleton" style={{ height: 86, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  const totalMonthly = expenses.reduce((s, e) => s + (+e.monthly_amount || 0), 0)
  const activeCount = expenses.filter(e => e.active).length

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>8</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Recurring Expenses</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Subscriptions, EMIs, and regular bills.</p>

      {expenses.length > 0 && (
        <div className="card" style={{ padding: '14px 18px', marginBottom: 16 }}>
          <div style={{ display: 'flex', gap: 20, flexWrap: 'wrap' }}>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Monthly Total</span>
              <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--coral)' }}>₹{totalMonthly.toLocaleString('en-IN')}</p></div>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Active</span>
              <p style={{ fontSize: 16, fontWeight: 600, color: 'var(--emerald)' }}>{activeCount}/{expenses.length}</p></div>
          </div>
        </div>
      )}

      {expenses.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">↻</span>
          <p>No recurring expenses</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Add your monthly subscriptions and bills so you never miss a payment.</p>
        </div>
      ) : expenses.map(e => (
        <div key={e.id} className="card" style={{ padding: '14px 18px', marginBottom: 6, opacity: e.active ? 1 : 0.5 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 6 }}>
            <div>
              <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{e.name}</p>
              <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>
                {e.frequency} · {e.category}
                {e.auto_debit && <span> · auto-debit</span>}
              </p>
            </div>
            <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 17, fontWeight: 600 }}>₹{(+e.amount).toLocaleString('en-IN')}</p>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 11.5 }}>
            <span className="tag" style={{ background: e.active ? 'var(--emerald)' : 'var(--line)', color: e.active ? '#fff' : 'var(--ink-mute)' }}>
              {e.active ? 'active' : 'inactive'}
            </span>
            {e.next_due_date && (
              <span style={{ color: 'var(--ink-faint)' }}>
                {e.next_due_date} · {daysText(e.next_due_days)}
              </span>
            )}
          </div>
        </div>
      ))}
    </div>
  )
}
