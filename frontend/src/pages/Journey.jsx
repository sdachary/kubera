import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Journey() {
  const [journey, setJourney] = useState(null)
  const [progress, setProgress] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([
      api.request('/api/v1/journey'),
      api.request('/api/v1/journey/progress'),
    ]).then(([j, p]) => { setJourney(j); setProgress(p) })
      .catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      {[1,2,3,4].map(i => <div key={i} className="skeleton" style={{ height: 80, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  if (!journey) return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>12</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Your Journey</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Your path to financial freedom.</p>
      <div className="empty-state">
        <span className="emoji">→</span>
        <p>Start your financial journey</p>
        <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Track your first debt or investment to see your journey unfold.</p>
      </div>
    </div>
  )

  const d = journey.debt || {}
  const s = journey.sip || {}
  const nw = journey.net_worth || {}
  const milestones = journey.milestones || progress?.milestones || []
  const sipProgress = progress?.sip_progress || s

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>12</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Your Journey</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Your path to financial freedom.</p>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 10, marginBottom: 16 }}>
        <div className="card" style={{ padding: '16px' }}>
          <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 4 }}>Net Worth</p>
          <p className="fin" style={{ fontSize: 20, fontWeight: 600, color: (+nw.net_worth || 0) >= 0 ? 'var(--emerald)' : 'var(--coral)' }}>
            ₹{(+nw.net_worth || 0).toLocaleString('en-IN')}
          </p>
          <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>Assets: ₹{(+nw.assets || 0).toLocaleString('en-IN')} · Liab: ₹{(+nw.liabilities || 0).toLocaleString('en-IN')}</p>
        </div>
        <div className="card" style={{ padding: '16px' }}>
          <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 4 }}>Total Debt</p>
          <p className="fin" style={{ fontSize: 20, fontWeight: 600, color: 'var(--coral)' }}>₹{(+d.total_debt || 0).toLocaleString('en-IN')}</p>
          {d.total_emi && <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>EMI: ₹{(+d.total_emi).toLocaleString('en-IN')}/mo</p>}
        </div>
        <div className="card" style={{ padding: '16px' }}>
          <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 4 }}>SIP Progress</p>
          <p className="fin" style={{ fontSize: 20, fontWeight: 600, color: 'var(--emerald)' }}>{sipProgress.progress || 0}%</p>
          <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>Goal: ₹{(+s.monthly_goal || 0).toLocaleString('en-IN')}/mo</p>
        </div>
      </div>

      {milestones.length > 0 && (
        <div>
          <h2 style={{ fontSize: 14, fontWeight: 600, marginBottom: 10, letterSpacing: '-0.01em' }}>Milestones</h2>
          {milestones.map((m, i) => (
            <div key={i} className="card" style={{ padding: '12px 16px', marginBottom: 6, borderLeft: '3px solid var(--emerald)' }}>
              <p style={{ fontWeight: 600, fontSize: 13, marginBottom: 2 }}>{m.title || m.name}</p>
              {m.date && <p style={{ fontSize: 11, color: 'var(--ink-mute)' }}>{m.date}</p>}
            </div>
          ))}
        </div>
      )}

      {progress?.net_worth_trajectory?.length > 0 && (
        <div style={{ marginTop: 16 }}>
          <h2 style={{ fontSize: 14, fontWeight: 600, marginBottom: 10, letterSpacing: '-0.01em' }}>Net Worth Trajectory</h2>
          <div className="card" style={{ padding: '16px' }}>
            {progress.net_worth_trajectory.slice(0, 12).map((pt, i) => (
              <div key={i} style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, padding: '3px 0', borderBottom: i < 11 ? '1px solid var(--line-soft)' : 'none' }}>
                <span style={{ color: 'var(--ink-mute)' }}>{pt.date || pt.month}</span>
                <span className="fin" style={{ fontWeight: 500 }}>₹{(+pt.net_worth || 0).toLocaleString('en-IN')}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
