import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Transactions() {
  const [txns, setTxns] = useState([])
  const [totals, setTotals] = useState([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('')

  const load = (type) => {
    setLoading(true)
    setFilter(type)
    const params = type ? `?transaction_type=${type}` : ''
    Promise.all([
      api.request('/api/v1/transactions/monthly_totals'),
      api.request(`/api/v1/transactions${params}`),
    ]).then(([t, d]) => { setTotals(t || []); setTxns(Array.isArray(d?.transactions) ? d.transactions : []) })
      .catch(() => {}).finally(() => setLoading(false))
  }
  useEffect(() => load(''), [])

  if (loading) return (
    <div>
      <div className="skeleton" style={{ width: 120, height: 22, marginBottom: 6 }} />
      <div className="skeleton" style={{ width: 200, height: 14, marginBottom: 20 }} />
      {[1,2,3].map(i => <div key={i} className="skeleton" style={{ height: 76, marginBottom: 8, borderRadius: 'var(--radius)' }} />)}
    </div>
  )

  const monthTotals = totals.slice(-3)
  const totalExpenses = txns.filter(t => t.transaction_type === 'expense').reduce((s, t) => s + (+t.amount), 0)
  const totalIncome = txns.filter(t => t.transaction_type === 'income').reduce((s, t) => s + (+t.amount), 0)

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>6</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Transactions</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Track every rupee in and out.</p>

      <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
        {monthTotals.map(m => (
          <div key={m.month} className="card" style={{ flex: '1 0 160px', padding: '14px 16px' }}>
            <p style={{ fontSize: 11, color: 'var(--ink-mute)', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.05em' }}>{m.label}</p>
            <p className="fin" style={{ fontSize: 15, fontWeight: 600, color: 'var(--emerald)' }}>+₹{(+m.income).toLocaleString('en-IN')}</p>
            <p className="fin" style={{ fontSize: 15, fontWeight: 600, color: 'var(--coral)' }}>-₹{(+m.expenses).toLocaleString('en-IN')}</p>
            <p className="fin" style={{ fontSize: 13, fontWeight: 500, color: +m.net >= 0 ? 'var(--emerald)' : 'var(--coral)' }}>=₹{(+m.net).toLocaleString('en-IN')}</p>
          </div>
        ))}
      </div>

      <div style={{ display: 'flex', gap: 8, marginBottom: 14, flexWrap: 'wrap' }}>
        {['', 'expense', 'income'].map(f => (
          <button key={f} onClick={() => load(f)}
            style={{ padding: '5px 14px', borderRadius: 20, border: '1px solid var(--line)', background: filter === f ? 'var(--coral)' : 'transparent', color: filter === f ? '#fff' : 'var(--ink-soft)', fontSize: 12, cursor: 'pointer' }}>
            {f || 'All'}
          </button>
        ))}
        {txns.length > 0 && <span style={{ marginLeft: 'auto', fontSize: 11, color: 'var(--ink-faint)', alignSelf: 'center' }}>{txns.length} txns</span>}
      </div>

      {txns.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">↗</span>
          <p>No transactions yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Start tracking your spending to see patterns emerge.</p>
        </div>
      ) : (
        <div style={{ display: 'flex', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
          <div className="card" style={{ padding: '10px 16px' }}>
            <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Income</p>
            <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--emerald)' }}>₹{totalIncome.toLocaleString('en-IN')}</p>
          </div>
          <div className="card" style={{ padding: '10px 16px' }}>
            <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Expenses</p>
            <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: 'var(--coral)' }}>₹{totalExpenses.toLocaleString('en-IN')}</p>
          </div>
          <div className="card" style={{ padding: '10px 16px' }}>
            <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Net</p>
            <p className="fin" style={{ fontSize: 16, fontWeight: 600, color: totalIncome - totalExpenses >= 0 ? 'var(--emerald)' : 'var(--coral)' }}>₹{(totalIncome - totalExpenses).toLocaleString('en-IN')}</p>
          </div>
        </div>
      )}

      {txns.map(t => (
        <div key={t.id} className="card" style={{ padding: '14px 18px', marginBottom: 6, borderLeft: `3px solid ${t.transaction_type === 'expense' ? 'var(--coral)' : 'var(--emerald)'}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <div style={{ flex: 1 }}>
              <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{t.description}</p>
              <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>
                {t.category_name && <span style={{ color: 'var(--ink-soft)' }}>{t.category_name} · </span>}
                {t.transaction_date} {t.merchant && <span>· {t.merchant}</span>}
                {t.recurring && <span className="tag" style={{ marginLeft: 6, fontSize: 9 }}>recurring</span>}
              </p>
            </div>
            <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 17, fontWeight: 600, color: t.transaction_type === 'expense' ? 'var(--coral)' : 'var(--emerald)', whiteSpace: 'nowrap', marginLeft: 12 }}>
              {t.transaction_type === 'expense' ? '-' : '+'}₹{(+t.amount).toLocaleString('en-IN')}
            </p>
          </div>
        </div>
      ))}
    </div>
  )
}
