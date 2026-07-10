import { useState } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'
import { useAuth } from '../lib/auth'

export default function Login() {
  const { user, login } = useAuth()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  if (user) return <Navigate to="/dashboard" replace />

  const handleSubmit = async (e) => {
    e.preventDefault()
    try {
      await login(email, password)
      navigate('/dashboard')
    } catch (err) {
      setError(err.message)
    }
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 24px' }}>
      <div style={{ width: '100%', maxWidth: 360 }}>
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <Link to="/" style={{ fontFamily: 'var(--sans)', fontWeight: 700, fontSize: 20, letterSpacing: '-0.02em', color: 'var(--ink)' }}>Kubera</Link>
        </div>
        <div className="card" style={{ padding: 32 }}>
          <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Welcome back</h1>
          <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 24 }}>Sign in to your account</p>
          {error && <p style={{ fontSize: 13, color: 'var(--coral)', marginBottom: 16 }}>{error}</p>}
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            <input type="email" placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} className="input" required />
            <input type="password" placeholder="Password" value={password} onChange={e => setPassword(e.target.value)} className="input" required />
            <button type="submit" className="btn btn-primary" style={{ justifyContent: 'center', marginTop: 6 }}>Sign in</button>
          </form>
        </div>
        <p style={{ textAlign: 'center', fontSize: 13, color: 'var(--ink-mute)', marginTop: 20 }}>
          No account? <Link to="/register" style={{ color: 'var(--coral)' }}>Register</Link>
        </p>
      </div>
    </div>
  )
}
