import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'
import { useAuth } from '../lib/auth'

export default function Dashboard() {
  const { user } = useAuth()
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.dashboard().then(setData).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div>
      <div className="skeleton" style={{ width: 180, height: 22, marginBottom: 6 }} />
      <div className="skeleton" style={{ width: 260, height: 14, marginBottom: 24 }} />
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px,1fr))', gap: 14 }}>
        {[1,2,3,4].map(i => <div key={i} className="skeleton" style={{ height: 100 }} />)}
      </div>
    </div>
  )

  const nw = data?.net_worth ?? 0
  const debt = data?.total_debt ?? 0
  const inv = data?.total_investments ?? 0
  const pct = debt + inv > 0 ? Math.round((inv / (debt + inv)) * 100) : 50
  const snapshots = data?.recent_snapshots ?? []

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>1</em> / 016</p>

      {/* hero net worth */}
      <div className="card" style={{ padding: '28px 26px', marginBottom: 20 }}>
        <p style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Net worth</p>
        <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 36, fontWeight: 700, letterSpacing: '-0.03em', lineHeight: 1.1 }}>
          ₹{(nw).toLocaleString('en-IN')}
        </p>
        {data?.debt_free_date && (
          <p style={{ fontSize: 13, color: 'var(--ink-mute)', marginTop: 8 }}>
            Debt-free by <span style={{ color: 'var(--ink)' }}>{data.debt_free_date}</span>
          </p>
        )}
        {debt > 0 && (
          <div style={{ marginTop: 12 }}>
            <div className="progress" style={{ maxWidth: 300 }}>
              <div className="progress-fill green" style={{ width: `${pct}%` }} />
            </div>
            <p style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 4 }}>{pct}% invested · {100 - pct}% debt</p>
          </div>
        )}
      </div>

      {/* stat grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(170px,1fr))', gap: 12, marginBottom: 20 }}>
        <div className="card" style={{ padding: '18px 20px' }}>
          <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Total debt</p>
          <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 22, fontWeight: 600, letterSpacing: '-0.02em', color: 'var(--coral)' }}>₹{debt.toLocaleString('en-IN')}</p>
          {data?.debt_count > 0 && <p style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 2 }}>{data.debt_count} loan{data.debt_count > 1 ? 's' : ''}</p>}
        </div>
        <div className="card" style={{ padding: '18px 20px' }}>
          <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Investments</p>
          <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 22, fontWeight: 600, letterSpacing: '-0.02em', color: '#2d7d6a' }}>₹{inv.toLocaleString('en-IN')}</p>
          {data?.portfolio_count > 0 && <p style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 2 }}>{data.portfolio_count} portfolio{data.portfolio_count > 1 ? 's' : ''}</p>}
        </div>
        <div className="card" style={{ padding: '18px 20px' }}>
          <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Monthly expenses</p>
          <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 22, fontWeight: 600, letterSpacing: '-0.02em' }}>₹{(data?.monthly_expenses || 0).toLocaleString('en-IN')}</p>
        </div>
        <div className="card" style={{ padding: '18px 20px' }}>
          <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Wealth score</p>
          <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 22, fontWeight: 600, letterSpacing: '-0.02em' }}>{(data?.wealth_score || 0).toFixed(1)}</p>
        </div>
      </div>

      {/* snapshot chart */}
      {snapshots.length > 1 && (
        <div className="card" style={{ padding: 20, marginBottom: 20 }}>
          <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 12 }}>Net worth trend</p>
          <div style={{ display: 'flex', alignItems: 'flex-end', gap: 3, height: 64 }}>
            {snapshots.map((s, i) => (
              <div key={i} style={{
                flex: 1, background: 'var(--coral)', borderRadius: '2px 2px 0 0',
                opacity: 0.35 + (i / snapshots.length) * 0.65,
                height: `${Math.max(6, (s.net_worth / Math.max(...snapshots.map(x => x.net_worth))) * 100)}%`,
              }} title={`${s.date}: ₹${(+s.net_worth).toLocaleString('en-IN')}`} />
            ))}
          </div>
        </div>
      )}

      {/* quick actions */}
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 20 }}>
        <Link to="/dashboard/transactions" className="btn btn-ghost" style={{ fontSize: 12.5, padding: '7px 16px' }}>+ Add transaction</Link>
        <Link to="/dashboard/debts" className="btn btn-ghost" style={{ fontSize: 12.5, padding: '7px 16px' }}>+ Log payment</Link>
        {data?.unread_notifications > 0 && (
          <span className="tag coral" style={{ marginLeft: 'auto' }}>
            <span className="pulse" style={{ width: 5, height: 5, borderRadius: '50%', background: 'var(--coral)', display: 'inline-block' }} />
            {data.unread_notifications} unread
          </span>
        )}
      </div>

      {/* contextual info */}
      <div style={{ fontSize: 13, color: 'var(--ink-mute)', display: 'flex', gap: 16, flexWrap: 'wrap' }}>
        {data?.sip_count > 0 && <span>{data.sip_count} active SIP{data.sip_count > 1 ? 's' : ''}</span>}
        {data?.currency_symbol && <span>Base: {data.currency_symbol}</span>}
      </div>
    </div>
  )
}
