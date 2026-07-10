import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Journey() {
  const [journey, setJourney] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.request('/api/v1/journey').then(setJourney).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return <div><div className="skeleton" style={{ height: 100 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>12</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Your Journey</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Your path to financial freedom.</p>
      {!journey && (
        <div className="empty-state">
          <span className="emoji">→</span>
          <p>Start your financial journey</p>
          <p style={{ fontSize: 12, color: 'var(--ink-faint)' }}>Track your first debt or investment to see your journey unfold.</p>
        </div>
      )}
    </div>
  )
}
