import { useEffect, useRef } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../lib/auth'

function useReveal() {
  useEffect(() => {
    const els = document.querySelectorAll('[data-reveal]')
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target) } })
    }, { threshold: 0.1 })
    els.forEach(el => observer.observe(el))
    return () => observer.disconnect()
  }, [])
}

function Stat({ n, label }) {
  return (
    <div className="stat" data-reveal>
      <span className="stat-n">{n}</span>
      <span className="stat-label">{label}</span>
      <style>{`.stat { text-align: center; } .stat-n { display: block; font-family: var(--sans); font-size: 26px; font-weight: 600; letter-spacing: -0.03em; line-height: 1; } .stat-label { font-size: 11px; color: var(--ink-mute); letter-spacing: 0.08em; text-transform: uppercase; }`}</style>
    </div>
  )
}

function Feature({ n, title, desc }) {
  return (
    <div className="feature" data-reveal>
      <div className="feature-num"><em>{String(n).padStart(2, '0')}</em></div>
      <h3 className="feature-title">{title}</h3>
      <p className="feature-desc">{desc}</p>
      <style>{`
.feature { padding: 28px 24px; background: #faf9f7; border: 1px solid var(--line); border-radius: var(--radius); transition: transform 0.2s ease; }
.feature:hover { transform: translateY(-2px); }
.feature-num em { font-family: var(--serif); font-style: italic; font-size: 14px; color: var(--coral); }
.feature-title { font-family: var(--sans); font-size: 17px; font-weight: 600; margin: 10px 0 6px; letter-spacing: -0.02em; }
.feature-desc { font-size: 13.5px; color: var(--ink-mute); line-height: 1.55; }
`}</style>
    </div>
  )
}

const features = [
  { n: 1, title: 'Track Every Rupee', desc: 'Log debts, investments, and expenses. See where your money goes, all in one place.' },
  { n: 2, title: 'Know Your Net Worth', desc: 'Real-time snapshots of your financial health. Watch your wealth grow month over month.' },
  { n: 3, title: 'Plan Your Freedom', desc: 'Set debt-free targets, project your journey, and stay motivated with clear milestones.' },
  { n: 4, title: 'Stay on Track', desc: 'Recurring expense reminders, SIP tracking, and smart notifications — so nothing slips.' },
]

export default function Landing() {
  const { user } = useAuth()
  const navigate = useNavigate()
  useReveal()

  if (user) { navigate('/dashboard', { replace: true }); return null }

  return (
    <div style={{ maxWidth: 960, margin: '0 auto', padding: '0 24px' }}>
      {/* nav */}
      <nav style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '20px 0', borderBottom: '1px solid var(--line)' }}>
        <span style={{ fontFamily: 'var(--sans)', fontWeight: 700, fontSize: 17, letterSpacing: '-0.02em' }}>Kubera</span>
        <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
          <Link to="/login" style={{ fontSize: 13.5, color: 'var(--ink-mute)' }}>Sign in</Link>
          <Link to="/register" className="btn btn-primary" style={{ padding: '8px 18px', fontSize: 13 }}>Get started</Link>
        </div>
      </nav>

      {/* hero */}
      <section style={{ padding: '80px 0 60px', textAlign: 'center' }} data-reveal>
        <p className="page-num" style={{ marginBottom: 12 }}>00<em>1</em> / 004</p>
        <h1 style={{ fontSize: 44, fontWeight: 700, letterSpacing: '-0.03em', lineHeight: 1.15, marginBottom: 16 }}>
          Your finances,<br />in <em style={{ fontFamily: 'var(--serif)', fontStyle: 'italic', color: 'var(--coral)' }}>one</em> clear picture
        </h1>
        <p style={{ fontSize: 16, color: 'var(--ink-mute)', maxWidth: 460, margin: '0 auto 32px', lineHeight: 1.6 }}>
          Kubera tracks your debts, investments, and net worth — so you always know where you stand.
        </p>
        <div style={{ display: 'flex', gap: 12, justifyContent: 'center' }}>
          <Link to="/register" className="btn btn-primary">Start free</Link>
          <Link to="/login" className="btn btn-ghost">Sign in</Link>
        </div>
        <img src="/dashboard-preview.png" alt="Kubera dashboard showing net worth, budget envelopes, and investment portfolio" style={{ marginTop: 48, borderRadius: 12, border: '1px solid var(--line-soft)', maxWidth: '100%', boxShadow: '0 8px 32px rgba(0,0,0,0.08)' }} />
      </section>

      {/* stats */}
      <div style={{ display: 'flex', justifyContent: 'center', gap: 48, padding: '40px 0', borderTop: '1px solid var(--line-soft)', borderBottom: '1px solid var(--line-soft)' }}>
        <div data-reveal>
          <span style={{ display: 'block', fontFamily: 'var(--sans)', fontSize: 28, fontWeight: 600, letterSpacing: '-0.03em', lineHeight: 1 }}>Zero</span>
          <span style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase' }}>Debt goal</span>
        </div>
        <div data-reveal>
          <span style={{ display: 'block', fontFamily: 'var(--sans)', fontSize: 28, fontWeight: 600, letterSpacing: '-0.03em', lineHeight: 1 }}>Real-time</span>
          <span style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase' }}>Net worth</span>
        </div>
        <div data-reveal>
          <span style={{ display: 'block', fontFamily: 'var(--sans)', fontSize: 28, fontWeight: 600, letterSpacing: '-0.03em', lineHeight: 1 }}>One app</span>
          <span style={{ fontSize: 11, color: 'var(--ink-mute)', letterSpacing: '0.08em', textTransform: 'uppercase' }}>All finances</span>
        </div>
      </div>

      {/* features */}
      <section style={{ padding: '60px 0' }}>
        <p className="page-num" style={{ marginBottom: 6, textAlign: 'center' }}>00<em>2</em> / 004</p>
        <h2 style={{ textAlign: 'center', fontSize: 26, fontWeight: 600, letterSpacing: '-0.025em', marginBottom: 40 }}>
          What Kubera <em style={{ fontFamily: 'var(--serif)', fontStyle: 'italic', color: 'var(--coral)' }}>does</em>
        </h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 16 }}>
          {features.map(f => <Feature key={f.n} {...f} />)}
        </div>
      </section>

      {/* CTA */}
      <section style={{ padding: '50px 0 70px', textAlign: 'center', borderTop: '1px solid var(--line-soft)' }} data-reveal>
        <p className="page-num" style={{ marginBottom: 12 }}>00<em>3</em> / 004</p>
        <h2 style={{ fontSize: 22, fontWeight: 600, letterSpacing: '-0.025em', marginBottom: 10 }}>
          Ready to take <em style={{ fontFamily: 'var(--serif)', fontStyle: 'italic', color: 'var(--coral)' }}>control</em>?
        </h2>
        <p style={{ fontSize: 14, color: 'var(--ink-mute)', marginBottom: 24 }}>Join Kubera and see your complete financial picture.</p>
        <Link to="/register" className="btn btn-primary">Get started</Link>
      </section>

      {/* footer */}
      <footer style={{ padding: '20px 0', borderTop: '1px solid var(--line-soft)', fontSize: 12, color: 'var(--ink-faint)', textAlign: 'center' }}>
        Kubera &mdash; financial clarity
      </footer>
    </div>
  )
}
