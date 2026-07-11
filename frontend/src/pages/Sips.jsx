import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Sips() {
  const [sips, setSips] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/dividend_sips').then(d => setSips(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      {[1,2].map(i => <div key={i} className="skeleton" style={{ height: 110, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  const totalMonthly = sips.reduce((sum, s) => sum + (+s.monthly_investment || 0), 0)
  const totalProjected = sips.reduce((sum, s) => sum + (+s.projected_annual_income || 0), 0)

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>11</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>SIPs</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Systematic Investment Plans.</p>

      {sips.length > 0 && (
        <div className="card" style={{ padding: '14px 18px', marginBottom: 16 }}>
          <div style={{ display: 'flex', gap: 20, flexWrap: 'wrap' }}>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Monthly Investment</span>
              <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--coral)' }}>₹{totalMonthly.toLocaleString('en-IN')}</p></div>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Projected Annual</span>
              <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--emerald)' }}>₹{totalProjected.toLocaleString('en-IN')}</p></div>
          </div>
        </div>
      )}

      {sips.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">◒</span>
          <p>No SIPs active</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Set up recurring investments to build wealth automatically.</p>
        </div>
      ) : sips.map(s => (
        <div key={s.id} className="card" style={{ padding: '14px 18px', marginBottom: 8 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 6 }}>
            <div>
              <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{s.name}</p>
              <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>{s.frequency} · {s.status}</p>
            </div>
            <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 17, fontWeight: 600 }}>₹{(+s.monthly_investment || 0).toLocaleString('en-IN')}/mo</p>
          </div>
          <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap', marginBottom: 6 }}>
            {s.target_income && <span className="tag" style={{ fontSize: 10 }}>target ₹{(+s.target_income).toLocaleString('en-IN')}/mo</span>}
            {s.projected_annual_income && <span className="tag green" style={{ fontSize: 10 }}>₹{(+s.projected_annual_income).toLocaleString('en-IN')}/yr projected</span>}
          </div>
          <div style={{ fontSize: 11.5, color: 'var(--ink-faint)', display: 'flex', justifyContent: 'space-between' }}>
            <span>Status: <span style={{ color: s.status === 'active' ? 'var(--emerald)' : 'var(--ink-mute)' }}>{s.status}</span></span>
            {s.next_execution && <span>Next: {s.next_execution}</span>}
          </div>
        </div>
      ))}
    </div>
  )
}
