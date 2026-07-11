import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Investments() {
  const [investments, setInvestments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/investments').then(d => setInvestments(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      {[1,2,3].map(i => <div key={i} className="skeleton" style={{ height: 100, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  const totalValue = investments.reduce((s, i) => s + (+i.current_value || 0), 0)
  const totalGain = investments.reduce((s, i) => s + (+i.gain_loss || 0), 0)

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>10</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Investments</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Individual holdings across portfolios.</p>

      {investments.length > 0 && (
        <div className="card" style={{ padding: '14px 18px', marginBottom: 16 }}>
          <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Value</span>
              <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--emerald)' }}>₹{totalValue.toLocaleString('en-IN')}</p></div>
            <div><span style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total P&L</span>
              <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: totalGain >= 0 ? 'var(--emerald)' : 'var(--coral)' }}>
                {totalGain >= 0 ? '+' : ''}₹{totalGain.toLocaleString('en-IN')}</p></div>
          </div>
        </div>
      )}

      {investments.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">◑</span>
          <p>No investments recorded</p>
        </div>
      ) : investments.map(i => {
        const gain = +i.gain_loss || 0
        const gainPct = +i.gain_loss_pct || 0
        return (
          <div key={i.id} className="card" style={{ padding: '14px 18px', marginBottom: 6 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 6 }}>
              <div>
                <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 1 }}>{i.symbol} <span style={{ fontWeight: 400, fontSize: 12, color: 'var(--ink-mute)' }}>{i.name}</span></p>
                <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>
                  {i.shares} shares @ ₹{(+i.buy_price).toLocaleString('en-IN')}
                  {i.exchange && <span> · {i.exchange}</span>}
                </p>
              </div>
              <div style={{ textAlign: 'right' }}>
                <p className="fin" style={{ fontSize: 16, fontWeight: 600 }}>₹{(+i.current_value || 0).toLocaleString('en-IN')}</p>
                <p className="fin" style={{ fontSize: 12, color: gain >= 0 ? 'var(--emerald)' : 'var(--coral)' }}>
                  {gain >= 0 ? '+' : ''}₹{gain.toLocaleString('en-IN')} ({gainPct >= 0 ? '+' : ''}{gainPct.toFixed(1)}%)
                </p>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
              {i.sector && <span className="tag" style={{ fontSize: 10 }}>{i.sector}</span>}
              {i.investment_type && <span className="tag" style={{ fontSize: 10 }}>{i.investment_type}</span>}
              {i.dividend_yield != null && +i.dividend_yield > 0 && <span className="tag" style={{ fontSize: 10, background: 'var(--emerald)', color: '#fff' }}>{i.dividend_yield}% div</span>}
            </div>
          </div>
        )
      })}
    </div>
  )
}
