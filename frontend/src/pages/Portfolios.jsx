import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Portfolios() {
  const [portfolios, setPortfolios] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/portfolios').then(d => setPortfolios(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      {[1,2].map(i => <div key={i} className="skeleton" style={{ height: 130, marginBottom: 10, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  const totalValue = portfolios.reduce((s, p) => s + (+p.total_value || 0), 0)

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>9</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Portfolios</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>All your investments, one view.</p>

      {portfolios.length > 0 && (
        <div className="card" style={{ padding: '14px 18px', marginBottom: 16 }}>
          <span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Portfolio Value</span>
          <p className="fin" style={{ fontSize: 22, fontWeight: 600, color: 'var(--emerald)' }}>₹{totalValue.toLocaleString('en-IN')}</p>
        </div>
      )}

      {portfolios.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">◐</span>
          <p>No portfolios yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Track your mutual funds, stocks, and other investments here.</p>
        </div>
      ) : portfolios.map(p => {
        const sectors = p.allocation_summary?.sectors || {}
        const sectorNames = Object.keys(sectors)
        return (
          <div key={p.id} className="card" style={{ padding: '16px 18px', marginBottom: 10 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
              <div>
                <p style={{ fontWeight: 600, fontSize: 15, marginBottom: 2 }}>{p.name}</p>
                <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>
                  {p.goal && <span style={{ textTransform: 'capitalize' }}>{p.goal}</span>}
                  {p.risk_tolerance != null && <span> · risk {p.risk_tolerance}/10</span>}
                </p>
              </div>
              <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 18, fontWeight: 600, color: 'var(--emerald)' }}>
                ₹{(+p.total_value || 0).toLocaleString('en-IN')}
              </p>
            </div>
            {sectorNames.length > 0 && (
              <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
                {sectorNames.map(s => (
                  <span key={s} className="tag" style={{ fontSize: 10 }}>{s} {sectors[s]}%</span>
                ))}
              </div>
            )}
            {p.investments?.length > 0 && (
              <p style={{ fontSize: 11, color: 'var(--ink-faint)', marginTop: 6 }}>{p.investments.length} investment{p.investments.length !== 1 ? 's' : ''}</p>
            )}
          </div>
        )
      })}
    </div>
  )
}
