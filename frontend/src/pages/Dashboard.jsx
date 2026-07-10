import { useState, useEffect } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../lib/auth'

function StatCard({ label, value, accent }) {
  return (
    <div className="card" style={{ padding: '24px 22px' }}>
      <p style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 6 }}>{label}</p>
      <p style={{ fontFamily: 'var(--sans)', fontSize: 28, fontWeight: 600, letterSpacing: '-0.03em', lineHeight: 1, color: accent || 'var(--ink)' }}>{value ?? '—'}</p>
    </div>
  )
}

export default function Dashboard() {
  const { user } = useAuth()
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.dashboard()
      .then(setData)
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  return (
    <div>
      <div style={{ marginBottom: 28 }}>
        <p className="page-num" style={{ marginBottom: 4 }}>00<em>1</em></p>
        <h1 style={{ fontSize: 22, fontWeight: 600, letterSpacing: '-0.025em', marginBottom: 2 }}>Dashboard</h1>
        <p style={{ fontSize: 13.5, color: 'var(--ink-mute)' }}>Welcome{user?.first_name ? `, ${user.first_name}` : ''}</p>
      </div>

      {loading ? (
        <p style={{ fontSize: 13.5, color: 'var(--ink-faint)' }}>Loading...</p>
      ) : (
        <>
          {/* snapshot chart placeholder */}
          {data?.recent_snapshots?.length > 0 && (
            <div className="card" style={{ padding: 24, marginBottom: 20 }}>
              <p style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 14 }}>Net worth over time</p>
              <div style={{ display: 'flex', alignItems: 'flex-end', gap: 3, height: 80 }}>
                {data.recent_snapshots.map((s, i) => (
                  <div key={i} style={{
                    flex: 1, background: 'var(--coral)', borderRadius: '3px 3px 0 0', opacity: 0.4 + (i / data.recent_snapshots.length) * 0.6,
                    height: `${Math.max(8, (s.net_worth / Math.max(...data.recent_snapshots.map(x => x.net_worth))) * 100)}%`,
                  }} title={`${s.date}: ${s.net_worth}`} />
                ))}
              </div>
            </div>
          )}

          {/* stat cards */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 14 }}>
            <StatCard label="Net worth" value={data?.net_worth?.toLocaleString()} />
            <StatCard label="Total debt" value={data?.total_debt?.toLocaleString()} accent="var(--coral)" />
            <StatCard label="Investments" value={data?.total_investments?.toLocaleString()} />
            <StatCard label="Monthly expenses" value={data?.monthly_expenses?.toLocaleString()} />
          </div>

          {/* contextual data */}
          <div style={{ marginTop: 28, display: 'flex', gap: 14, flexWrap: 'wrap', fontSize: 13, color: 'var(--ink-mute)' }}>
            {data?.portfolio_count > 0 && <span>{data.portfolio_count} portfolio{data.portfolio_count > 1 ? 's' : ''}</span>}
            {data?.debt_count > 0 && <span>{data.debt_count} debt{data.debt_count > 1 ? 's' : ''}</span>}
            {data?.sip_count > 0 && <span>{data.sip_count} active SIP{data.sip_count > 1 ? 's' : ''}</span>}
            {data?.wealth_score != null && <span>Wealth score: {data.wealth_score.toFixed(1)}</span>}
            {data?.debt_free_date && <span>Debt-free by: {data.debt_free_date}</span>}
            {data?.unread_notifications > 0 && (
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5 }}>
                <span className="pulse" style={{ width: 6, height: 6, borderRadius: '50%', background: 'var(--coral)', display: 'inline-block' }} />
                {data.unread_notifications} notification{data.unread_notifications > 1 ? 's' : ''}
              </span>
            )}
          </div>
        </>
      )}
    </div>
  )
}
