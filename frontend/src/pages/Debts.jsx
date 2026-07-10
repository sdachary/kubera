import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'

function DebtCard({ debt }) {
  const total = debt.original_amount || debt.amount
  const paid = total - debt.amount
  const pct = total > 0 ? Math.round((paid / total) * 100) : 0

  return (
    <div className="card" style={{ padding: '18px 20px', borderLeft: '3px solid var(--coral)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
        <div>
          <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{debt.name}</p>
          <p style={{ fontSize: 12, color: 'var(--ink-mute)' }}>{debt.category || 'Loan'} · {debt.interest_rate}% APR</p>
        </div>
        <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 18, fontWeight: 600, color: 'var(--coral)' }}>₹{(+debt.amount).toLocaleString('en-IN')}</p>
      </div>
      <div className="progress" style={{ marginBottom: 4 }}><div className="progress-fill" style={{ width: `${pct}%` }} /></div>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11.5, color: 'var(--ink-faint)' }}>
        <span>{pct}% paid off</span>
        {debt.emi_amount && <span className="fin">EMI: ₹{(+debt.emi_amount).toLocaleString('en-IN')}/mo</span>}
      </div>
    </div>
  )
}

export default function Debts() {
  const [debts, setDebts] = useState([])
  const [loading, setLoading] = useState(true)
  const [total, setTotal] = useState(0)

  useEffect(() => {
    api.request('/api/v1/debts').then(d => {
      setDebts(d)
      setTotal(d.reduce((s, x) => s + (+x.amount || 0), 0))
    }).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      <div className="skeleton" style={{ width: 120, height: 22, marginBottom: 6 }} />
      <div className="skeleton" style={{ width: 200, height: 14, marginBottom: 20 }} />
      {[1,2,3].map(i => <div key={i} className="skeleton" style={{ height: 100, marginBottom: 10 }} />)}
    </div>
  )

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>4</em> / 016</p>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
        <div>
          <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em' }}>Debts</h1>
          {total > 0 && <p className="fin" style={{ fontSize: 13, color: 'var(--ink-mute)', marginTop: 2 }}>Total: ₹{total.toLocaleString('en-IN')}</p>}
        </div>
        <Link to="/dashboard/debt-payoffs" className="btn btn-ghost" style={{ fontSize: 12.5, padding: '7px 16px' }}>Payoff plan</Link>
      </div>

      {debts.length === 0 && (
        <div className="empty-state">
          <span className="emoji">○</span>
          <p>No debts tracked yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Add your first debt to start planning your payoff journey.</p>
        </div>
      )}

      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {debts.map(d => <DebtCard key={d.id} debt={d} />)}
      </div>
    </div>
  )
}
