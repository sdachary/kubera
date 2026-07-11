import { useState, useEffect } from 'react'
import { api } from '../lib/api'

export default function Conversations() {
  const [convs, setConvs] = useState([])
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState(null)
  const [messages, setMessages] = useState([])
  const [newTitle, setNewTitle] = useState('')

  useEffect(() => {
    api.request('/conversations').then(d => setConvs(Array.isArray(d) ? d : [])).catch(() => {}).finally(() => setLoading(false))
  }, [])

  const openConv = async (id) => {
    const c = convs.find(x => x.id === id)
    if (!c) return
    setSelected(c)
    api.request(`/conversations/${id}`).then(d => setMessages(d?.messages || [])).catch(() => {})
  }

  const createConv = async () => {
    if (!newTitle.trim()) return
    try {
      const res = await api.request('/conversations', {
        method: 'POST',
        body: JSON.stringify({ title: newTitle }),
        headers: { 'Content-Type': 'application/json' },
      })
      setConvs(prev => [res, ...prev])
      setNewTitle('')
      setSelected(res)
      setMessages([])
    } catch {}
  }

  if (selected) return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>14</em> / 016</p>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
        <button onClick={() => { setSelected(null); setMessages([]) }} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, padding: 0, color: 'var(--ink-soft)' }}>←</button>
        <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em' }}>{selected.title}</h1>
      </div>
      {selected.summary && <p style={{ fontSize: 12, color: 'var(--ink-mute)', marginBottom: 16 }}>{selected.summary}</p>}
      {messages.length === 0 ? (
        <div className="empty-state"><span className="emoji">◉</span><p>No messages</p></div>
      ) : messages.map(m => (
        <div key={m.id} className="card" style={{ padding: '12px 16px', marginBottom: 6, borderLeft: `3px solid ${m.role === 'user' ? 'var(--coral)' : 'var(--emerald)'}` }}>
          <p style={{ fontSize: 11, color: 'var(--ink-mute)', marginBottom: 4, textTransform: 'capitalize' }}>{m.role}</p>
          <p style={{ fontSize: 13, lineHeight: 1.5 }}>{m.content}</p>
          <p style={{ fontSize: 10, color: 'var(--ink-faint)', marginTop: 4 }}>{new Date(m.created_at).toLocaleString()}</p>
        </div>
      ))}
    </div>
  )

  if (loading) return <div><div className="skeleton" style={{ height: 200 }} /></div>

  return (
    <div>
      <p className="page-num" style={{ marginBottom: 4 }}>00<em>14</em> / 016</p>
      <h1 style={{ fontSize: 20, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 4 }}>Conversations</h1>
      <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', marginBottom: 16 }}>Chat with household members.</p>

      <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
        <input value={newTitle} onChange={e => setNewTitle(e.target.value)} placeholder="New conversation title…"
          className="input" style={{ flex: 1, padding: '9px 12px', fontSize: 13 }} />
        <button onClick={createConv} disabled={!newTitle.trim()} className="btn btn-primary" style={{ fontSize: 12.5, padding: '7px 16px' }}>Create</button>
      </div>

      {convs.length === 0 ? (
        <div className="empty-state"><span className="emoji">◉</span><p>No conversations yet</p></div>
      ) : convs.map(c => (
        <div key={c.id} className="card" style={{ padding: '14px 18px', marginBottom: 6, cursor: 'pointer' }} onClick={() => openConv(c.id)}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <p style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{c.title}</p>
              {c.summary && <p style={{ fontSize: 12, color: 'var(--ink-mute)' }}>{c.summary}</p>}
            </div>
            <span style={{ fontSize: 16, color: 'var(--ink-faint)' }}>→</span>
          </div>
        </div>
      ))}
    </div>
  )
}
