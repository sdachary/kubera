export default function Label({ htmlFor, children, style, ...props }) {
  return (
    <label htmlFor={htmlFor} style={{ fontSize: 12, color: 'var(--ink-mute)', display: 'block', marginBottom: 4, ...style }} {...props}>
      {children}
    </label>
  )
}
