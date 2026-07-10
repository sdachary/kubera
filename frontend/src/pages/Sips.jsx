import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Sips() {
  const [sips, setSips] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/dividend_sips').then(d => setSips(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>11</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>SIPs</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Systematic Investment Plans.</p>
      {sips.length === 0 && (
        <div className="empty-state">
          <span className="emoji">◒</span>
          <p>No SIPs active</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Set up recurring investments to build wealth automatically.</p>
        </div>
      )}
    </div>
  )
}
