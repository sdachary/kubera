export const typography = {
  fontFamily: {
    sans: "'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
    mono: "'Space Mono', ui-monospace, SFMono-Regular, Menlo, monospace"
  },
  display: {
    h1: {
      fontSize: 'clamp(2rem, 5vw, 3.5rem)',
      fontWeight: 800,
      lineHeight: 1.2,
      letterSpacing: '-0.025em',
      fontFamily: 'var(--font-sans)'
    },
    h2: {
      fontSize: 'clamp(1.5rem, 4vw, 2.5rem)',
      fontWeight: 700,
      lineHeight: 1.3,
      letterSpacing: '-0.025em',
      fontFamily: 'var(--font-sans)'
    },
    h3: {
      fontSize: 'clamp(1.25rem, 3vw, 2rem)',
      fontWeight: 600,
      lineHeight: 1.4,
      fontFamily: 'var(--font-sans)'
    }
  },
  body: {
    default: {
      fontSize: '1rem',
      lineHeight: 1.6,
      fontFamily: 'var(--font-sans)'
    },
    small: {
      fontSize: '0.875rem',
      lineHeight: 1.5,
      fontFamily: 'var(--font-sans)'
    }
  },
  code: {
    fontFamily: 'var(--font-mono)',
    fontSize: '0.875rem',
    lineHeight: 1.5
  }
};
