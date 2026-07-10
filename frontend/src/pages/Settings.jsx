import { useAuth } from '../lib/auth'

export default function Settings() {
  const { user } = useAuth()
  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>17</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Settings</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Account preferences and profile.</p>
      <div className="card" style={{ padding: 20, maxWidth: 400 }}>
        <p style={{ fontSize: 13, marginBottom: 2 }}>{user?.first_name} {user?.last_name}</p>
        <p style={{ fontSize: 12, color: 'var(--ink-mute)' }}>{user?.email}</p>
      </div>
    </div>
  )
}
