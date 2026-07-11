import { useState } from 'react'
import { useAuth } from '../lib/auth'
import { api } from '../lib/api'

export default function Settings() {
  const { user } = useAuth()
  const [msg, setMsg] = useState('')

  const handleExport = async () => {
    try {
      const token = localStorage.getItem('token')
      const res = await fetch('/api/dpdp/full-export', {
        method: 'POST',
        headers: { Authorization: `Bearer ${token}` },
      })
      const blob = await res.blob()
      const a = document.createElement('a')
      a.href = URL.createObjectURL(blob)
      a.download = `kubera-full-export-${new Date().toISOString().slice(0, 10)}.json`
      a.click()
      setMsg('Full export downloaded')
    } catch { setMsg('Export failed') }
    setTimeout(() => setMsg(''), 3000)
  }

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>17</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Settings</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Account preferences and profile.</p>

      {msg && (
        <div className="card" style={{ padding: '10px 16px', marginBottom: 12, fontSize: 13, color: msg.startsWith('Error') ? 'var(--coral)' : 'var(--emerald)' }}>
          {msg}
        </div>
      )}

      <div className="card" style={{ padding: '18px 20px', marginBottom: 12 }}>
        <p style={{ fontSize: 12, fontWeight: 600, marginBottom: 10, letterSpacing: '-0.01em' }}>Profile</p>
        <div style={{ display: 'grid', gap: 8 }}>
          <div>
            <p style={{ fontSize: 11, color: 'var(--ink-mute)', marginBottom: 2 }}>Name</p>
            <p style={{ fontSize: 14, fontWeight: 500 }}>{user?.first_name} {user?.last_name}</p>
          </div>
          <div>
            <p style={{ fontSize: 11, color: 'var(--ink-mute)', marginBottom: 2 }}>Email</p>
            <p style={{ fontSize: 14, fontWeight: 500 }}>{user?.email}</p>
          </div>
          <div>
            <p style={{ fontSize: 11, color: 'var(--ink-mute)', marginBottom: 2 }}>Currency</p>
            <p style={{ fontSize: 14, fontWeight: 500 }}>{user?.currency || 'INR'}</p>
          </div>
        </div>
      </div>

      <div className="card" style={{ padding: '18px 20px', marginBottom: 12 }}>
        <p style={{ fontSize: 12, fontWeight: 600, marginBottom: 8, letterSpacing: '-0.01em' }}>Data</p>
        <button onClick={handleExport} className="btn btn-ghost" style={{ fontSize: 12.5, padding: '7px 16px' }}>
          Download full export (DPDP)
        </button>
      </div>
    </div>
  )
}
