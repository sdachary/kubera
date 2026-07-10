import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Households() {
  const [households, setHouseholds] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/households').then(d => setHouseholds(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>13</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Households</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Shared finances with family.</p>
      {households.length === 0 && (
        <div className="empty-state">
          <span className="emoji">◈</span>
          <p>No households yet</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Create a household to manage shared expenses and goals.</p>
        </div>
      )}
    </div>
  )
}
