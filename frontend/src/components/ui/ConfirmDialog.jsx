import Modal from './Modal'

export default function ConfirmDialog({ open, title, message, onConfirm, onCancel, confirmLabel, danger }) {
  return (
    <Modal open={open} onClose={onCancel} title={title || 'Confirm'} style={{ maxWidth: 380 }}>
      <p style={{ fontSize: 14, color: 'var(--ink-mute)', marginBottom: 20 }}>{message}</p>
      <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
        <button onClick={onCancel} className="btn btn-ghost">Cancel</button>
        <button onClick={onConfirm} className="btn" style={{
          background: danger ? 'var(--coral)' : 'var(--ink)',
          color: 'var(--paper)', border: 'none', borderRadius: 999, padding: '8px 20px',
          fontSize: 13, fontWeight: 500, cursor: 'pointer',
        }}>{confirmLabel || 'Confirm'}</button>
      </div>
    </Modal>
  )
}
