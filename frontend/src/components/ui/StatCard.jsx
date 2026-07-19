export default function StatCard({ label, value, subtext, color, tooltip, style }) {
  return (
    <div className="card" style={{ padding: '18px 20px', ...style }}>
      <p style={{ fontSize: 10.5, color: 'var(--ink-faint)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
        {label}
        {tooltip && <span title={tooltip} style={{ cursor: 'help', marginLeft: 4, fontSize: 11, color: 'var(--ink-faint)' }}>ⓘ</span>}
      </p>
      <p className="fin" style={{ fontFamily: 'var(--sans)', fontSize: 22, fontWeight: 600, letterSpacing: '-0.02em', color: color || 'var(--ink)' }}>{value}</p>
      {subtext && <p style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 2 }}>{subtext}</p>}
    </div>
  )
}
