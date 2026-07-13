import { useState, useEffect, useCallback } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'
import DebtFormModal from '../components/DebtFormModal'

function DebtCard({ debt, onEdit, onDelete }) {
  const pct = debt.amount > 0 ? Math.round(((+debt.paid_amount || 0) / debt.amount) * 100) : 0

  return (
    <div className="card" style={{ padding: '18px 20px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 10 }}>
        <div onClick={() => onEdit(debt)} style={{ cursor: 'pointer', flex: 1 }}>
          <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{debt.name}</p>
          <p style={{ fontSize: 12, color: 'var(--ink-mute)' }}>{debt.category || 'Loan'} · {debt.interest_rate}% APR</p>
        </div>
        <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 18, fontWeight: 600, color: 'var(--coral)' }}>₹{(+debt.amount).toLocaleString('en-IN')}</p>
      </div>
      <div className="progress" style={{ marginBottom: 4 }}>
        <div className="progress-fill" style={{ width: `${Math.min(pct, 100)}%` }} />
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11.5, color: 'var(--ink-faint)', marginBottom: 10 }}>
        <span>{pct}% paid off</span>
        <span>
          {debt.emi_amount && <span className="fin">EMI: ₹{(+debt.emi_amount).toLocaleString('en-IN')}/mo</span>}
          {debt.status !== 'active' && <span className="tag" style={{ marginLeft: 8 }}>{debt.status.replace('_', ' ')}</span>}
        </span>
      </div>
      <div style={{ display: 'flex', gap: 8, borderTop: '1px solid var(--line-soft)', paddingTop: 10 }}>
        <button onClick={() => onEdit(debt)} className="btn btn-ghost" style={{ fontSize: 11.5, padding: '4px 12px' }}>Edit</button>
        <button onClick={() => onDelete(debt)} style={{ fontSize: 11.5, padding: '4px 12px', background: 'none', border: 'none', borderRadius: 999, color: 'var(--ink-faint)', cursor: 'pointer' }}>Delete</button>
      </div>
    </div>
  )
}

export default function Debts() {
  const [debts, setDebts] = useState([])
  const [loading, setLoading] = useState(true)
  const [modal, setModal] = useState(null)
  const [total, setTotal] = useState(0)

  const fetch = useCallback(async () => {
    try {
      const d = await api.request('/api/v1/debts')
      setDebts(d)
      setTotal(d.reduce((s, x) => s + (+x.amount || 0), 0))
    } catch {} finally { setLoading(false) }
  }, [])

  useEffect(() => { fetch() }, [fetch])

  const handleDelete = (debt) => {
    if (!confirm(`Delete "${debt.name}"?`)) return
    api.request(`/api/v1/debts/${debt.id}`, { method: 'DELETE' })
      .then(fetch)
      .catch(e => alert(e.message))
  }

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
        <div style={{ display: 'flex', gap: 8 }}>
          <button onClick={() => setModal('new')} className="btn btn-primary" style={{ fontSize: 12.5, padding: '7px 16px' }}>+ Add</button>
          <Link to="/dashboard/debt-payoffs" className="btn btn-ghost" style={{ fontSize: 12.5, padding: '7px 16px' }}>Plan</Link>
        </div>
      </div>

      {debts.length === 0 && (
        <div className="empty-state">
          <span className="emoji">○</span>
          <p>No debts tracked yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Add your first debt to start planning your payoff journey.</p>
          <button onClick={() => setModal('new')} className="btn btn-primary" style={{ marginTop: 12 }}>+ Add Debt</button>
        </div>
      )}

      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {debts.map(d => (
          <DebtCard
            key={d.id}
            debt={d}
            onEdit={(debt) => setModal(debt)}
            onDelete={handleDelete}
          />
        ))}
      </div>

      {modal && (
        <DebtFormModal
          debt={modal === 'new' ? null : modal}
          onClose={() => setModal(null)}
          onSave={() => { setModal(null); fetch() }}
        />
      )}
    </div>
  )
}
