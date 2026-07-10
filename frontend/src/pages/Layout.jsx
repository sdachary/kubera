import { Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../lib/auth'

export default function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  return (
    <div style={{ minHeight: '100vh', background: 'var(--paper)' }}>
      <header style={{ borderBottom: '1px solid var(--line)', padding: '14px 24px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span style={{ fontFamily: 'var(--sans)', fontWeight: 700, fontSize: 16, letterSpacing: '-0.02em' }}>Kubera</span>
        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <span style={{ fontSize: 12.5, color: 'var(--ink-faint)' }}>{user?.email}</span>
          <button onClick={async () => { await logout(); navigate('/') }} className="btn btn-ghost" style={{ padding: '6px 14px', fontSize: 12.5 }}>Sign out</button>
        </div>
      </header>
      <main style={{ maxWidth: 900, margin: '0 auto', padding: '28px 24px' }}>
        <Outlet />
      </main>
    </div>
  )
}
