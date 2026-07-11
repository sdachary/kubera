import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Households() {
  const [households, setHouseholds] = useState([])
  const [detail, setDetail] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/households').then(d => setHouseholds(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  const loadDetail = (id) => {
    api.request(`/api/v1/households/${id}/dashboard`).then(setDetail).catch(() => {})
  }

  if (loading) return (
    <div>
      {[1,2].map(i => <div key={i} className="skeleton" style={{ height: 80, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  if (detail) return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>13</em> / 016</p>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
        <button onClick={() => setDetail(null)} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, padding: 0, color: 'var(--ink-soft)' }}>←</button>
        <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em' }}>{detail.name}</h1>
        <span className="tag" style={{ fontSize: 10 }}>{detail.member_count} members</span>
      </div>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Shared finances with family.</p>

      {detail.net_worth && (
        <div className="card" style={{ padding: '14px 18px', marginBottom: 12 }}>
          <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 4 }}>Household Net Worth</p>
          <p className="fin" style={{ fontSize: 20, fontWeight: 600 }}>{detail.currency_symbol}₹{(+detail.net_worth.net_worth || 0).toLocaleString('en-IN')}</p>
          <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>Assets: ₹{(+detail.net_worth.total_assets || 0).toLocaleString('en-IN')} · Liabilities: ₹{(+detail.net_worth.total_liabilities || 0).toLocaleString('en-IN')}</p>
        </div>
      )}

      {detail.members?.length > 0 && (
        <div style={{ marginBottom: 16 }}>
          <h2 style={{ fontSize: 13, fontWeight: 600, marginBottom: 8 }}>Members</h2>
          {detail.members.map(m => (
            <div key={m.id} className="card" style={{ padding: '12px 16px', marginBottom: 6 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div>
                  <p style={{ fontWeight: 600, fontSize: 13 }}>{m.name}</p>
                  <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>{m.email} · {m.role}</p>
                </div>
                <span className="tag" style={{ fontSize: 10, textTransform: 'capitalize' }}>{m.role}</span>
              </div>
              <div style={{ display: 'flex', gap: 12, marginTop: 6, fontSize: 11, color: 'var(--ink-mute)' }}>
                <span>Debt: ₹{(+m.total_debt || 0).toLocaleString('en-IN')}</span>
                <span>Invest: ₹{(+m.total_investments || 0).toLocaleString('en-IN')}</span>
                <span>Expenses: ₹{(+m.monthly_expenses || 0).toLocaleString('en-IN')}/mo</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>13</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Households</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Shared finances with family.</p>

      {households.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">◈</span>
          <p>No households yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Create a household to manage shared expenses and goals.</p>
        </div>
      ) : households.map(h => (
        <div key={h.id} className="card" style={{ padding: '14px 18px', marginBottom: 8, cursor: 'pointer' }} onClick={() => loadDetail(h.id)}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <p style={{ fontWeight: 600, fontSize: 15, marginBottom: 2 }}>{h.name}</p>
              <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>{h.currency} · {h.member_count} member{h.member_count !== 1 ? 's' : ''}</p>
            </div>
            <span style={{ fontSize: 16, color: 'var(--ink-faint)' }}>→</span>
          </div>
          {h.description && <p style={{ fontSize: 12, color: 'var(--ink-mute)', marginTop: 6 }}>{h.description}</p>}
        </div>
      ))}
    </div>
  )
}
