import { useState } from 'react'
import { Outlet, useNavigate, useLocation, Link } from 'react-router-dom'
import { useAuth } from '../lib/auth'

const groups = [
  { name: 'Dashboard', path: '/dashboard', icon: '◇' },
  { name: 'Money', children: [
    { name: 'Transactions', path: '/dashboard/transactions', icon: '↗' },
    { name: 'Budgets', path: '/dashboard/budgets', icon: '□' },
    { name: 'Recurring', path: '/dashboard/recurring', icon: '↻' },
  ]},
  { name: 'Debt', children: [
    { name: 'Debts', path: '/dashboard/debts', icon: '○' },
    { name: 'Payoff Plans', path: '/dashboard/payoff-plans', icon: '⬡' },
    { name: 'Simulator', path: '/dashboard/debt-payoffs', icon: '◎' },
  ]},
  { name: 'Investments', children: [
    { name: 'Portfolios', path: '/dashboard/portfolios', icon: '◐' },
    { name: 'Investments', path: '/dashboard/investments', icon: '◑' },
    { name: 'SIPs', path: '/dashboard/sips', icon: '◒' },
  ]},
  { name: 'Journey', path: '/dashboard/journey', icon: '→' },
  { name: 'More', children: [
    { name: 'Trip Mode', path: '/dashboard/trips', icon: '✈' },
    { name: 'Households', path: '/dashboard/households', icon: '◈' },
    { name: 'Conversations', path: '/dashboard/conversations', icon: '◉' },
    { name: 'Reports', path: '/dashboard/reports', icon: '▤' },
    { name: 'Exports', path: '/dashboard/exports', icon: '▥' },
    { name: 'Settings', path: '/dashboard/settings', icon: '⚙' },
    { name: 'Privacy', path: '/dashboard/privacy', icon: '▣' },
  ]},
]

function NavLink({ item, current, depth, onNav }) {
  const active = item.path === current || (item.path && current.startsWith(item.path))
  return (
    <Link to={item.path} onClick={onNav}
      style={{
        display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', marginLeft: depth ? 16 : 0,
        borderRadius: 6, fontSize: 13, fontWeight: active ? 500 : 400,
        color: active ? 'var(--coral)' : 'var(--ink)',
        background: active ? 'rgba(237,111,92,0.08)' : 'transparent',
        transition: 'all 0.15s ease',
      }}>
      <span style={{ fontSize: 12, opacity: 0.6, flexShrink: 0 }}>{item.icon}</span>
      <span>{item.name}</span>
    </Link>
  )
}

export default function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [menuOpen, setMenuOpen] = useState(false)

  const handleLogout = async () => { await logout(); navigate('/') }
  const initials = user ? (user.first_name?.[0] || '') + (user.last_name?.[0] || '') : '?'
  const isActive = (path) => location.pathname === path

  return (
    <div className="app-layout">
      {/* sidebar */}
      <aside className="sidebar">
        <div style={{ padding: '16px 14px', borderBottom: '1px solid var(--line)', marginBottom: 8 }}>
          <Link to="/dashboard" style={{ fontFamily: 'var(--sans)', fontWeight: 700, fontSize: 16, letterSpacing: '-0.02em', color: 'var(--ink)' }}>Kubera</Link>
        </div>
        <nav style={{ padding: '0 8px', flex: 1, overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 2 }}>
          {groups.map((g) => (
            <div key={g.name}>
              {g.children ? (
                <>
                  <div style={{ padding: '8px 12px 4px', fontSize: 10, fontWeight: 600, color: 'var(--ink-faint)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>{g.name}</div>
                  {g.children.map(c => <NavLink key={c.path} item={c} current={location.pathname} depth={1} />)}
                </>
              ) : (
                <NavLink item={g} current={location.pathname} />
              )}
            </div>
          ))}
        </nav>

        {/* user menu */}
        <div style={{ position: 'relative', borderTop: '1px solid var(--line)' }}>
          <button onClick={() => setMenuOpen(!menuOpen)}
            style={{
              width: '100%', display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px',
              background: 'none', border: 'none', cursor: 'pointer', color: 'var(--ink)', fontSize: 12,
            }}>
            <span style={{
              width: 30, height: 30, borderRadius: '50%', background: 'var(--coral)', color: '#fff',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 12, fontWeight: 600, flexShrink: 0,
            }}>{initials}</span>
            <span style={{ flex: 1, textAlign: 'left', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {user?.first_name || user?.email}
            </span>
            <span style={{ fontSize: 10, color: 'var(--ink-faint)', transform: menuOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s' }}>▾</span>
          </button>

          {menuOpen && (
            <div style={{
              position: 'absolute', bottom: '100%', left: 8, right: 8,
              background: '#faf9f7', border: '1px solid var(--line)', borderRadius: 10,
              boxShadow: '0 -8px 30px rgba(21,20,15,0.1)', padding: 6, marginBottom: 4,
            }}>
              {[
                { name: 'Settings', path: '/dashboard/settings', icon: '⚙' },
                { name: 'Privacy', path: '/dashboard/privacy', icon: '▣' },
                { name: 'Logout', action: handleLogout, icon: '↩' },
              ].map(item => (
                item.action ? (
                  <button key={item.name} onClick={() => { setMenuOpen(false); item.action() }}
                    style={{
                      display: 'flex', alignItems: 'center', gap: 8, padding: '8px 12px', width: '100%',
                      borderRadius: 6, border: 'none', background: 'none', cursor: 'pointer',
                      fontSize: 13, color: item.name === 'Logout' ? 'var(--coral)' : 'var(--ink)', textAlign: 'left',
                    }}>
                    <span style={{ fontSize: 12, opacity: 0.6 }}>{item.icon}</span>
                    <span>{item.name}</span>
                  </button>
                ) : (
                  <Link key={item.name} to={item.path} onClick={() => setMenuOpen(false)}
                    style={{
                      display: 'flex', alignItems: 'center', gap: 8, padding: '8px 12px',
                      borderRadius: 6, fontSize: 13, color: isActive(item.path) ? 'var(--coral)' : 'var(--ink)', textDecoration: 'none',
                      background: isActive(item.path) ? 'rgba(237,111,92,0.08)' : 'transparent',
                    }}>
                    <span style={{ fontSize: 12, opacity: 0.6 }}>{item.icon}</span>
                    <span>{item.name}</span>
                  </Link>
                )
              ))}
            </div>
          )}
        </div>
      </aside>

      {/* mobile bottom nav */}
      <nav className="bottom-nav">
        {[
          { name: 'Home', path: '/dashboard', icon: '◇' },
          { name: 'Money', path: '/dashboard/transactions', icon: '↗' },
          { name: 'Debt', path: '/dashboard/debts', icon: '○' },
          { name: 'Invest', path: '/dashboard/portfolios', icon: '◐' },
          { name: 'More', path: '/dashboard/settings', icon: '⚙' },
        ].map(item => {
          const active = location.pathname === item.path
          return (
            <Link key={item.path} to={item.path}
              style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2, padding: '4px 0', fontSize: 10, color: active ? 'var(--coral)' : 'var(--ink-mute)', textDecoration: 'none' }}>
              <span style={{ fontSize: 16 }}>{item.icon}</span>
              <span>{item.name}</span>
            </Link>
          )
        })}
      </nav>

      {/* main */}
      <main className="main-area"><Outlet /></main>
    </div>
  )
}
