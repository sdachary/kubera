import { useState, useEffect, useCallback } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'
import PayoffPlanModal from '../components/PayoffPlanModal'

const INTL = { style: 'decimal', minimumFractionDigits: 0, maximumFractionDigits: 0 }

function formatAmount(v) {
  return `₹${(+v || 0).toLocaleString('en-IN', INTL)}`
}

export default function PayoffPlans() {
  const [plans, setPlans] = useState([])
  const [loading, setLoading] = useState(true)
  const [modal, setModal] = useState(null)

  const fetch = useCallback(async () => {
    try {
      const d = await api.request('/api/v1/payoff_plans')
      setPlans(Array.isArray(d) ? d : [])
    } catch {} finally { setLoading(false) }
  }, [])

  useEffect(() => { fetch() }, [fetch])

  if (loading) return (
    <div>
      <div className="skeleton" style={{ width: 120, height: 22, marginBottom: 6 }} />
      <div className="skeleton" style={{ width: 200, height: 14, marginBottom: 20 }} />
      {[1,2].map(i => <div key={i} className="skeleton" style={{ height: 120, marginBottom: 10 }} />)}
    </div>
  )

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>5</em> / 016</p>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
        <div>
          <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em' }}>Payoff Plans</h1>
          <p style={{ fontSize: 13, color: 'var(--ink-mute)', marginTop: 2 }}>Create and manage your debt payoff strategies</p>
        </div>
        <button onClick={() => setModal('new')} className="btn btn-primary" style={{ fontSize: 12.5, padding: '7px 16px' }}>+ New Plan</button>
      </div>

      {plans.length === 0 && (
        <div className="empty-state">
          <span className="emoji">◎</span>
          <p>No payoff plans yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Create a plan to see how avalanche or snowball strategies can save you money.</p>
          <button onClick={() => setModal('new')} className="btn btn-primary" style={{ marginTop: 12 }}>+ Create Plan</button>
        </div>
      )}

      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {plans.map(p => (
          <div key={p.id} className="card" style={{ padding: '18px 20px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 10 }}>
              <div>
                <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{p.name}</p>
                <p style={{ fontSize: 12, color: 'var(--ink-mute)' }}>
                  {p.strategy === 'avalanche' ? 'Avalanche' : 'Snowball'} ·
                  {p.debts?.length || 0} debt{p.debts?.length !== 1 ? 's' : ''} ·
                  Extra {formatAmount(p.extra_payment)}/mo
                </p>
              </div>
              <div style={{ display: 'flex', gap: 8, flexShrink: 0 }}>
                <span className={`tag ${p.strategy === 'avalanche' ? 'coral' : 'green'}`}>
                  {p.strategy}
                </span>
                <button onClick={() => setModal(p)} className="btn btn-ghost" style={{ fontSize: 11, padding: '4px 10px' }}>
                  Edit
                </button>
              </div>
            </div>

            {p.debt_free_date && (
              <div style={{ display: 'flex', gap: 20, flexWrap: 'wrap', marginBottom: 8 }}>
                <div>
                  <span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Debt Free</span>
                  <p className="fin" style={{ fontSize: 15, fontWeight: 600 }}>{new Date(p.debt_free_date).toLocaleDateString('en-IN', { month: 'short', year: 'numeric' })}</p>
                </div>
                <div>
                  <span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Interest Paid</span>
                  <p className="fin" style={{ fontSize: 15, fontWeight: 600, color: 'var(--coral)' }}>{p.total_interest_paid != null ? formatAmount(p.total_interest_paid) : '—'}</p>
                </div>
                <div>
                  <span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Interest Saved</span>
                  <p className="fin" style={{ fontSize: 15, fontWeight: 600, color: 'var(--emerald)' }}>{p.total_interest_saved != null ? formatAmount(p.total_interest_saved) : '—'}</p>
                </div>
                <div>
                  <span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Months Saved</span>
                  <p className="fin" style={{ fontSize: 15, fontWeight: 600, color: 'var(--emerald)' }}>{p.months_saved || 0}</p>
                </div>
              </div>
            )}

            {p.debts?.length > 0 && (
              <div style={{ borderTop: '1px solid var(--line-soft)', paddingTop: 8 }}>
                <p style={{ fontSize: 10, color: 'var(--ink-faint)', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.05em' }}>Included debts</p>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                  {p.debts.map(d => (
                    <span key={d.id} className="tag" style={{ fontSize: 10.5 }}>{d.name} · {formatAmount(d.amount)}</span>
                  ))}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>

      {modal && (
        <PayoffPlanModal
          plan={modal === 'new' ? null : modal}
          onClose={() => setModal(null)}
          onSave={() => { setModal(null); fetch() }}
        />
      )}
    </div>
  )
}
