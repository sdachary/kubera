export default function Conversations() {
  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>14</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Conversations</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 20 }}>Chat with household members.</p>
      <div className="empty-state"><span className="emoji">◉</span><p>No conversations yet</p></div>
    </div>
  )
}
