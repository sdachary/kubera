import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Investments() {
  const [investments, setInvestments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/investments').then(d => setInvestments(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>10</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Investments</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Individual holdings across portfolios.</p>
      {investments.length === 0 && (
        <div className="empty-state">
          <span className="emoji">◑</span>
          <p>No investments recorded</p>
        </div>
      )}
    </div>
  )
}
