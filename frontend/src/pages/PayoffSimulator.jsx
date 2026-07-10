import { Link } from 'react-router-dom'

export default function PayoffSimulator() {
  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>5</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Payoff Simulator</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 24 }}>See how extra payments or lump sums affect your debt-free date.</p>
      <div className="empty-state">
        <span className="emoji">◎</span>
        <p>Select a debt to simulate payoffs</p>
        <Link to="/dashboard/debts" className="btn btn-ghost" style={{ fontSize: 12.5 }}>View debts</Link>
      </div>
    </div>
  )
}
