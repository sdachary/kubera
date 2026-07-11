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
    { name: 'Payoff Simulator', path: '/dashboard/debt-payoffs', icon: '◎' },
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

  const handleLogout = async () => { await logout(); navigate('/') }

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
        <div style={{ padding: '10px 14px', borderTop: '1px solid var(--line)', fontSize: 12, color: 'var(--ink-faint)', display: 'flex', alignItems: 'center', gap: 8 }}>
          <span style={{ flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{user?.email}</span>
          <button onClick={handleLogout} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--ink-mute)', fontSize: 12, padding: 4, borderRadius: 4 }}>×</button>
        </div>
      </aside>

      {/* mobile bottom nav */}
      <nav className="bottom-nav">
        {[
          { name: 'Home', path: '/dashboard', icon: '◇' },
          { name: 'Money', path: '/dashboard/transactions', icon: '↗' },
          { name: 'Debt', path: '/dashboard/debts', icon: '○' },
          { name: 'Invest', path: '/dashboard/portfolios', icon: '◐' },
          { name: 'More', path: '/dashboard/trips', icon: '✈' },
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
