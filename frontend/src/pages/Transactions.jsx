import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Transactions() {
  const [txns, setTxns] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/transactions').then(d => setTxns(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>6</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Transactions</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Track every rupee in and out.</p>
      {txns.length === 0 && (
        <div className="empty-state">
          <span className="emoji">↗</span>
          <p>No transactions yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Start tracking your spending to see patterns emerge.</p>
        </div>
      )}
    </div>
  )
}
