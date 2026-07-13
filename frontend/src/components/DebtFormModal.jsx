import { useState } from 'react'
import { api } from '../lib/api'

const CATEGORIES = ['credit_card', 'loan', 'personal', 'mortgage', 'education', 'other']
const STATUSES = ['active', 'paid_default', 'paid_off', 'frozen']

export default function DebtFormModal({ debt, onClose, onSave }) {
  const isEdit = !!debt
  const [form, setForm] = useState({
    name: debt?.name || '',
    category: debt?.category || 'loan',
    amount: debt?.amount || '',
    interest_rate: debt?.interest_rate || '',
    emi_amount: debt?.emi_amount || '',
    status: debt?.status || 'active',
    paid_amount: debt?.paid_amount || '',
    started_at: debt?.started_at || '',
    notes: debt?.notes || '',
  })
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState(null)

  const set = (key) => (e) => setForm(f => ({ ...f, [key]: e.target.value }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    try {
      const body = {
        ...form,
        amount: parseFloat(form.amount) || 0,
        interest_rate: form.interest_rate ? parseFloat(form.interest_rate) : null,
        emi_amount: form.emi_amount ? parseFloat(form.emi_amount) : null,
        paid_amount: parseFloat(form.paid_amount) || 0,
      }
      if (isEdit) {
        await api.request(`/api/v1/debts/${debt.id}`, { method: 'PATCH', body: JSON.stringify(body) })
      } else {
        await api.request('/api/v1/debts', { method: 'POST', body: JSON.stringify(body) })
      }
      onSave()
    } catch (err) {
      setError(err.message)
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async () => {
    if (!confirm(`Delete "${debt.name}"? This cannot be undone.`)) return
    setSaving(true)
    try {
      await api.request(`/api/v1/debts/${debt.id}`, { method: 'DELETE' })
      onSave()
    } catch (err) {
      setError(err.message)
      setSaving(false)
    }
  }

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 1000,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: 'rgba(21,20,15,0.35)', backdropFilter: 'blur(4px)',
      padding: 16,
    }} onClick={onClose}>
      <div style={{
        background: '#faf9f7', borderRadius: 16, padding: 28,
        width: '100%', maxWidth: 480, maxHeight: '90dvh', overflowY: 'auto',
        border: '1px solid var(--line)', boxShadow: '0 24px 80px rgba(21,20,15,0.2)',
      }} onClick={e => e.stopPropagation()}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
          <h2 style={{ fontSize: 18, fontWeight: 600 }}>{isEdit ? 'Edit Debt' : 'Add Debt'}</h2>
          <button onClick={onClose} style={{ background: 'none', border: 'none', fontSize: 20, cursor: 'pointer', color: 'var(--ink-mute)', padding: 4 }}>✕</button>
        </div>

        {error && <div style={{ background: 'rgba(237,111,92,0.1)', color: 'var(--coral)', padding: '10px 14px', borderRadius: 8, fontSize: 13, marginBottom: 16 }}>{error}</div>}

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <div>
            <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Name *</label>
            <input required className="input" value={form.name} onChange={set('name')} placeholder="e.g. Home Loan" />
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Category</label>
              <select className="input" value={form.category} onChange={set('category')}>
                {CATEGORIES.map(c => <option key={c} value={c}>{c.charAt(0).toUpperCase() + c.slice(1)}</option>)}
              </select>
            </div>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Status</label>
              <select className="input" value={form.status} onChange={set('status')}>
                {STATUSES.map(s => <option key={s} value={s}>{s.replace('_', ' ')}</option>)}
              </select>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Amount (₹) *</label>
              <input required type="number" min="0" step="0.01" className="input" value={form.amount} onChange={set('amount')} placeholder="0" />
            </div>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Interest Rate (%)</label>
              <input type="number" min="0" step="0.1" className="input" value={form.interest_rate} onChange={set('interest_rate')} placeholder="0" />
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>EMI (₹/mo)</label>
              <input type="number" min="0" step="0.01" className="input" value={form.emi_amount} onChange={set('emi_amount')} placeholder="0" />
            </div>
            <div>
              <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Already Paid (₹)</label>
              <input type="number" min="0" step="0.01" className="input" value={form.paid_amount} onChange={set('paid_amount')} placeholder="0" />
            </div>
          </div>

          <div>
            <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Started Date</label>
            <input type="date" className="input" value={form.started_at} onChange={set('started_at')} />
          </div>

          <div>
            <label style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4 }}>Notes</label>
            <textarea className="input" rows="3" value={form.notes} onChange={set('notes')} placeholder="Optional notes..." style={{ resize: 'vertical' }} />
          </div>

          <div style={{ display: 'flex', gap: 10, marginTop: 8 }}>
            <button type="submit" disabled={saving} className="btn btn-primary" style={{ flex: 1, justifyContent: 'center' }}>
              {saving ? 'Saving…' : isEdit ? 'Update Debt' : 'Add Debt'}
            </button>
            {isEdit && (
              <button type="button" onClick={handleDelete} disabled={saving}
                style={{ padding: '10px 20px', borderRadius: 999, border: '1px solid var(--coral)', background: 'transparent', color: 'var(--coral)', cursor: 'pointer', fontSize: 13, fontWeight: 500 }}>
                Delete
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  )
}
