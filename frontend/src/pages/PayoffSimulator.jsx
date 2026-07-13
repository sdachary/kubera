import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'

export default function PayoffSimulator() {
  const [debts, setDebts] = useState([])
  const [selectedId, setSelectedId] = useState('')
  const [extraPayment, setExtraPayment] = useState(0)
  const [baseline, setBaseline] = useState(null)
  const [result, setResult] = useState(null)
  const [loading, setLoading] = useState(true)
  const [simulating, setSimulating] = useState(false)
  const [search, setSearch] = useState('')

  useEffect(() => {
    api.request('/api/v1/debt_payoffs').then(d => setDebts(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  const simulate = async () => {
    if (!selectedId) return
    setSimulating(true)
    try {
      const [base, res] = await Promise.all([
        api.request(`/api/v1/debt_payoffs/${selectedId}/simulate`, {
          method: 'POST', body: '{}', headers: { 'Content-Type': 'application/json' },
        }),
        api.request(`/api/v1/debt_payoffs/${selectedId}/simulate`, {
          method: 'POST',
          body: JSON.stringify({ extra_monthly_payment: +extraPayment || 0 }),
          headers: { 'Content-Type': 'application/json' },
        }),
      ])
      setBaseline(base)
      setResult(res)
    } catch {}
    setSimulating(false)
  }

  if (loading) return <div><div className="skeleton" style={{ height: 200 }} /></div>

  const selected = debts.find(d => d.id === +selectedId)
  const base = baseline
  const res = result
  const monthsSaved = base && res ? base.months - res.months : 0
  const interestSaved = base && res ? +base.total_interest - +res.total_interest : 0
  // JS fallback for browsers that don't support the native `filter` attribute
  const filtered = search ? debts.filter(d => d.name.toLowerCase().includes(search.toLowerCase())) : debts

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>5</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Payoff Simulator</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 24 }}>See how extra payments affect your debt-free date.</p>

      {debts.length === 0 ? (
        <div className="empty-state">
          <span className="emoji">◎</span>
          <p>Select a debt to simulate payoffs</p>
          <Link to="/dashboard/debts" className="btn btn-ghost" style={{ fontSize: 12.5 }}>View debts</Link>
        </div>
      ) : (
        <div>
          <div style={{ marginBottom: 16 }}>
            <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 6 }}>Select Debt</label>
            <input type="text" filter="debt-select" value={search} onChange={e => setSearch(e.target.value)}
              placeholder="Search debts…" className="input" style={{ maxWidth: 360, padding: '9px 12px', marginBottom: 6, fontSize: 14 }} />
            <select id="debt-select" value={selectedId} onChange={e => { setSelectedId(e.target.value); setBaseline(null); setResult(null) }}
              className="input" style={{ maxWidth: 360, padding: '9px 12px' }}>
              <option value="">Choose a debt…</option>
              {filtered.map(d => (
                <option key={d.id} value={d.id}>{d.name} — ₹{(+d.amount || 0).toLocaleString('en-IN')} @ {d.interest_rate}%</option>
              ))}
            </select>
            {search && filtered.length === 0 && <p style={{ fontSize: 11, color: 'var(--ink-faint)', marginTop: 4 }}>No debts match "{search}"</p>}
          </div>

          {selected && (
            <div className="card" style={{ padding: '14px 18px', marginBottom: 16 }}>
              <p style={{ fontSize: 12, fontWeight: 600, marginBottom: 4 }}>{selected.name}</p>
              <p style={{ fontSize: 11.5, color: 'var(--ink-mute)' }}>
                ₹{(+selected.amount || 0).toLocaleString('en-IN')} · {selected.interest_rate}% APR · EMI: ₹{(+selected.emi_amount || 0).toLocaleString('en-IN')}/mo
              </p>
            </div>
          )}

          <div style={{ marginBottom: 16 }}>
            <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 6 }}>Extra Monthly Payment (₹)</label>
            <input type="number" value={extraPayment} onChange={e => setExtraPayment(e.target.value)}
              className="input" style={{ maxWidth: 200, padding: '9px 12px' }} placeholder="0" min="0" />
          </div>

          <button onClick={simulate} disabled={!selectedId || simulating} className="btn btn-primary" style={{ fontSize: 13, padding: '9px 24px' }}>
            {simulating ? 'Simulating…' : 'Simulate'}
          </button>

          {res && base && (
            <div style={{ marginTop: 20 }}>
              <div className="card" style={{ padding: '16px 18px', marginBottom: 12 }}>
                <p style={{ fontSize: 12, fontWeight: 600, marginBottom: 12 }}>Comparison</p>
                <div style={{ display: 'flex', gap: 12, marginBottom: 14, flexWrap: 'wrap' }}>
                  <div style={{ flex: '1 1 140px' }}>
                    <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 2 }}>Current plan</p>
                    <p className="fin" style={{ fontSize: 24, fontWeight: 700, color: 'var(--coral)' }}>{base.months} mo</p>
                    <p className="fin" style={{ fontSize: 12, color: 'var(--ink-mute)' }}>₹{(+base.total_interest).toLocaleString('en-IN')} interest</p>
                  </div>
                  <div style={{ flex: '1 1 140px' }}>
                    <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 2 }}>With extra ₹{(+extraPayment || 0).toLocaleString('en-IN')}/mo</p>
                    <p className="fin" style={{ fontSize: 24, fontWeight: 700, color: 'var(--emerald)' }}>{res.months} mo</p>
                    <p className="fin" style={{ fontSize: 12, color: 'var(--ink-mute)' }}>₹{(+res.total_interest).toLocaleString('en-IN')} interest</p>
                  </div>
                </div>

                <div style={{ display: 'flex', gap: 8, alignItems: 'flex-end', height: 80 }}>
                  <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3 }}>
                    <span style={{ fontSize: 10, color: 'var(--ink-faint)' }}>{base.months}mo</span>
                    <div style={{ width: '50%', maxWidth: 80, background: 'var(--coral)', borderRadius: '4px 4px 0 0', opacity: 0.7, height: `${Math.min((base.months / base.months) * 64, 64)}px` }} />
                    <span style={{ fontSize: 9, color: 'var(--ink-mute)' }}>Current</span>
                  </div>
                  <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3 }}>
                    <span style={{ fontSize: 10, color: 'var(--ink-faint)' }}>{res.months}mo</span>
                    <div style={{ width: '50%', maxWidth: 80, background: 'var(--emerald)', borderRadius: '4px 4px 0 0', height: `${Math.min((res.months / base.months) * 64, 64)}px` }} />
                    <span style={{ fontSize: 9, color: 'var(--ink-mute)' }}>Extra</span>
                  </div>
                </div>
              </div>

              <div className="card" style={{ padding: '16px 18px', borderTop: '2px solid var(--success)' }}>
                <p style={{ fontSize: 12, fontWeight: 600, marginBottom: 8, letterSpacing: '-0.01em' }}>You save</p>
                <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
                  <div>
                    <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Time</p>
                    <p className="fin" style={{ fontSize: 22, fontWeight: 700, color: 'var(--emerald)' }}>{monthsSaved} months</p>
                  </div>
                  <div>
                    <p style={{ fontSize: 10, color: 'var(--ink-faint)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Interest</p>
                    <p className="fin" style={{ fontSize: 22, fontWeight: 700, color: 'var(--emerald)' }}>₹{interestSaved.toLocaleString('en-IN')}</p>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
